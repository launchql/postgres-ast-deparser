import { closeConnections, createUser, getConnections } from '../../utils';

let db, conn, powerUser, invite, blank;

const getInvite = async (conn, email) => {
  await conn.any(
    `INSERT INTO roles_public.invites
      ( email )
      VALUES
      ($1)`,
    [email]
  );
};

const getBlankInvite = async (conn) => {
  await conn.any(
    `INSERT INTO roles_public.invites
      ( expires_at )
      VALUES
      ( NOW() + interval '1 day' )`
  );
};

describe('invites', () => {
  beforeEach(async () => {
    ({ db, conn } = await getConnections());
    powerUser = await createUser(db);
    conn.setContext({
      role: 'authenticated',
      'jwt.claims.user_id': powerUser.id
    });
    await getInvite(conn, 'dude@webql.com');
    await getBlankInvite(conn);

    // use db to get token
    invite = await db.one('SELECT * FROM roles_public.invites WHERE email=$1', [
      'dude@webql.com'
    ]);
    blank = await db.one(
      'SELECT * FROM roles_public.invites WHERE email IS NULL'
    );
    expect(blank).toBeTruthy();
    expect(invite).toBeTruthy();
  });
  afterEach(async () => {
    await closeConnections({ db, conn });
  });
  it('using token w correct email', async () => {
    conn.setContext({
      role: 'anonymous'
    });

    const signupToken = await conn.one(
      'SELECT * FROM roles_public.sign_up($1, $2, $3, $4)',
      ['Dude Man', 'dude@webql.com', 'awesomepassword', invite.invite_token]
    );

    const secrets = await db.one(
      'SELECT * FROM roles_private.user_secrets WHERE role_id=$1',
      [signupToken.role_id]
    );

    expect(secrets).toEqual(
      expect.objectContaining({
        invites_approved: false,
        invited_by_id: powerUser.id
      })
    );
  });
  it('invite without an email', async () => {
    conn.setContext({
      role: 'anonymous'
    });

    const signupToken = await conn.one(
      'SELECT * FROM roles_public.sign_up($1, $2, $3, $4)',
      ['Dude Man', 'duder@webql.com', 'awesomepassword', blank.invite_token]
    );

    const secrets = await db.one(
      'SELECT * FROM roles_private.user_secrets WHERE role_id=$1',
      [signupToken.role_id]
    );

    expect(secrets).toEqual(
      expect.objectContaining({
        invites_approved: false,
        invited_by_id: powerUser.id
      })
    );
  });
  it('using token w different email', async () => {
    conn.setContext({
      role: 'anonymous'
    });

    let failed = false;
    try {
      await conn.any('SELECT * FROM roles_public.sign_up($1, $2, $3, $4)', [
        'John Doe',
        'user@gmail.com',
        'awesomepassword',
        invite.invite_token
      ]);
    } catch (e) {
      failed = true;
      expect(e.message).toEqual('INVITE_WRONG_EMAIL');
    }
    expect(failed).toBe(true);
  });
  it('inviter is a power user', async () => {
    conn.setContext({
      role: 'anonymous'
    });

    await db.none(
      'UPDATE roles_private.user_secrets SET invites_approved=TRUE WHERE role_id=$1',
      [powerUser.id]
    );

    const signupToken = await conn.one(
      'SELECT * FROM roles_public.sign_up($1, $2, $3, $4)',
      ['Dude Man', 'duder@webql.com', 'awesomepassword', blank.invite_token]
    );

    const secrets = await db.one(
      'SELECT * FROM roles_private.user_secrets WHERE role_id=$1',
      [signupToken.role_id]
    );

    expect(secrets).toEqual(
      expect.objectContaining({
        invites_approved: false,
        invited_by_id: powerUser.id
      })
    );
  });
  it('using token after signing up', async () => {
    await db.none(
      'UPDATE roles_private.user_secrets SET invites_approved=TRUE WHERE role_id=$1',
      [powerUser.id]
    );

    conn.setContext({
      role: 'anonymous'
    });

    const signupToken = await conn.one(
      'SELECT * FROM roles_public.sign_up($1, $2, $3)',
      ['Dude Man', 'dude@webql.com', 'awesomepassword']
    );

    conn.setContext({
      role: 'authenticated',
      'jwt.claims.user_id': signupToken.role_id
    });

    await conn.any('SELECT * FROM roles_public.submit_invite_code($1)', [
      invite.invite_token
    ]);

    const secrets = await db.one(
      'SELECT * FROM roles_private.user_secrets WHERE role_id=$1',
      [signupToken.role_id]
    );

    const inviteAfter = await db.one(
      'SELECT * FROM roles_public.invites WHERE invite_token=$1',
      [invite.invite_token]
    );

    expect(secrets).toEqual(
      expect.objectContaining({
        invites_approved: false,
        invited_by_id: powerUser.id
      })
    );
    expect(inviteAfter).toEqual(
      expect.objectContaining({
        invite_used: true
      })
    );
  });
});
