import { closeConnections, createUser, getConnections } from '../../utils';

let db, conn;

let objs = {
  profiles: {}
};

const inviteMember = async (
  conn,
  email,
  role_id,
  group_id,
  organization_id
) => {

  const profile_id = objs.profiles[organization_id].Contributor.id;
  await conn.any(
    `
    INSERT INTO roles_public.membership_invites
      ( role_id, email, group_id, profile_id, organization_id )
      VALUES
      ($1, $2, $3, $4, $5);
    `,
    [role_id, email, group_id, profile_id, organization_id]
  );
};


async function permitted_on_role(opts) {
  const { permitted_on_role: res } =  await db.one('SELECT permissions_private.permitted_on_role($1, $2, $3, $4)', [
    opts.action_type,
    opts.object_type,
    opts.role_id,
    opts.actor_id
  ]);
  return res;
}


const makeCase = (name) => {
  const [
    _can,
    username,
    action_type,
    object_type,
    _on,
    groupName
  ] = name.split(' ');
  return {
    name,
    action_type,
    object_type,
    role_id: objs[groupName] && objs[groupName].id,
    actor_id: objs[username] && objs[username].id
  };
};

describe('signup membership invites', () => {
  beforeEach(async () => {
    ({ db, conn } = await getConnections());
    objs.admin = await createUser(db);
    conn.setContext({
      role: 'authenticated',
      'jwt.claims.user_id': objs.admin.id
    });
    objs.organization1 = await conn.one(
      'SELECT * FROM roles_public.register_organization($1)',
      ['my amazing organization']
    );
    objs.organization2 = await conn.one(
      'SELECT * FROM roles_public.register_organization($1)',
      ['another amazing organization']
    );
    objs.profiles = await db.many(
      'SELECT * FROM permissions_public.profile'
    );
    objs.profiles = objs.profiles.reduce((m, profile) => {
      m[profile.organization_id] = m[profile.organization_id] || {};
      m[profile.organization_id][profile.name] = profile;
      return m;
    }, {});

    await inviteMember(
      conn,
      'dude@webql.com',
      null,
      objs.organization1.id,
      objs.organization1.id
    );
    await inviteMember(
      conn,
      'dude@webql.com',
      null,
      objs.organization2.id,
      objs.organization2.id
    );

    // use db to get token
    objs.invite1 = await db.one(
      'SELECT * FROM roles_public.membership_invites WHERE email=$1 AND group_id=$2',
      ['dude@webql.com', objs.organization1.id]
    );
    expect(objs.invite1).toBeTruthy();
    objs.invite2 = await db.one(
      'SELECT * FROM roles_public.membership_invites WHERE email=$1 AND group_id=$2',
      ['dude@webql.com', objs.organization2.id]
    );
    expect(objs.invite2).toBeTruthy();
  });
  afterEach(async () => {
    await closeConnections({ db, conn });
  });
  it('cannot sign up with token w different email', async () => {
    conn.setContext({
      role: 'anonymous'
    });

    let failed = false;
    try {
      await conn.any('SELECT * FROM roles_public.sign_up($1, $2, $3, $4)', [
        'John Doe',
        'user@gmail.com',
        'awesomepassword',
        objs.invite1.invite_token
      ]);
    } catch (e) {
      failed = true;
      expect(e.message).toEqual('INVITE_WRONG_EMAIL');
    }
    expect(failed).toBe(true);
  });
  it('inviter cannot accept for invitee', async () => {
    conn.setContext({
      role: 'anonymous'
    });

    await conn.one('SELECT * FROM roles_public.sign_up($1, $2, $3, $4)', [
      'John Doe',
      'dude@webql.com',
      'awesomepassword',
      objs.invite1.invite_token
    ]);

    conn.setContext({
      role: 'authenticated',
      'jwt.claims.user_id': objs.admin.id
    });

    let failed = false;
    try {
      const res = await conn.any(
        `UPDATE roles_public.membership_invites
        SET accepted=TRUE
        WHERE id=$1
        RETURNING id
        `,
        [objs.invite2.id]
      );
      console.log(res);
    } catch (e) {
      expect(e.message).toEqual('INVITES_ONLY_INVITEE_ACCEPT');
      failed = true;
    }
    expect(failed).toBe(true);
  });
  it('inviter cannot modify accept for invitee after its beeen accepted', async () => {
    conn.setContext({
      role: 'anonymous'
    });

    await conn.one('SELECT * FROM roles_public.sign_up($1, $2, $3, $4)', [
      'John Doe',
      'dude@webql.com',
      'awesomepassword',
      objs.invite1.invite_token
    ]);

    conn.setContext({
      role: 'authenticated',
      'jwt.claims.user_id': objs.admin.id
    });
    let failed = false;
    try {
      await conn.any(
        `UPDATE roles_public.membership_invites
        SET accepted=FALSE
        WHERE id=$1
        `,
        [objs.invite1.id]
      );
    } catch (e) {
      failed = true;
    }
    expect(failed).toBe(true);
  });
  it('sign up with token w same email', async () => {
    conn.setContext({
      role: 'anonymous'
    });

    const signupToken = await conn.one(
      'SELECT * FROM roles_public.sign_up($1, $2, $3, $4)',
      ['Dude Man', 'dude@webql.com', 'awesomepassword', objs.invite1.invite_token]
    );
    objs.newUser = await db.one(
      'SELECT * FROM roles_public.roles WHERE id=$1',
      [signupToken.role_id]
    );

    expect(objs.newUser.id).toBeTruthy();

    const email = await db.one(
      'SELECT * FROM roles_public.user_emails WHERE role_id=$1',
      [objs.newUser.id]
    );
    const inviteAfter = await db.one(
      'SELECT id, approved, accepted FROM roles_public.membership_invites WHERE role_id=$1 AND group_id=$2',
      [objs.newUser.id, objs.organization1.id]
    );
    expect(email.is_verified).toBe(true);
    expect(inviteAfter.approved).toBe(true);
    expect(inviteAfter.accepted).toBe(true);

    const secrets = await db.one(
      'SELECT * FROM roles_private.user_secrets WHERE role_id=$1',
      [objs.newUser.id]
    );
    expect(secrets.invited_by_id).toEqual(objs.admin.id);

    // NOW CAN SIGN IN
    const token = await conn.one('SELECT * FROM roles_public.sign_in($1, $2)', [
      'dude@webql.com',
      'awesomepassword'
    ]);
    expect(token.access_token).toBeTruthy();

    conn.setContext({
      role: 'authenticated',
      'jwt.claims.user_id': objs.newUser.id
    });

    // now get invites
    // gets all invites changed over that were associated with email
    const allInvites2 = await conn.many(
      'SELECT id, role_id, email, approved, accepted, sender_id FROM roles_public.membership_invites WHERE role_id=$1',
      [objs.newUser.id]
    );
    expect(allInvites2.length).toBe(2);

    // now accept all invites
    await conn.none(
      `UPDATE roles_public.membership_invites
        SET accepted=TRUE
        WHERE role_id=$1
        `,
      [objs.newUser.id]
    );


    const cases = [
      makeCase('can admin add team on organization1'),
      makeCase('can newUser add team on organization1'),
      makeCase('can admin browse invite on organization1'),
      makeCase('can admin edit invite on organization1'),
      makeCase('can admin destroy invite on organization1'),
      makeCase('can newUser browse invite on organization1'),
      makeCase('can newUser edit invite on organization1'),
      makeCase('can newUser destroy invite on organization1'),
    ];
    const results = {};
    for (let cs of cases) {
      await (async (cs) => {
        results[cs.name] = await permitted_on_role(cs);
      })(cs);
    }

    expect(results).toMatchSnapshot();


    // now we have 2 memberships
    const memberships = await conn.many(
      'SELECT * FROM roles_public.memberships WHERE role_id=$1', [
        objs.newUser.id
      ]
    );

    expect(memberships.length).toBe(2);
  });
});