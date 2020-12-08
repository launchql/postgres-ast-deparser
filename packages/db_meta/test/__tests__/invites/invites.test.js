import { assertFailureWithTx } from '../../utils/assertions';
import { getConnections } from '../../utils';
import initObjects from '../../utils/generic';
import { snap } from '../../utils/snaps';

let db, api, teardown;
const objs = {
  tables: {}
};

const anon = () =>
  db.setContext({
    role: 'anonymous'
  });

const postgres = () =>
  db.setContext({
    role: 'postgres'
  });

const auth = (user_id) =>
  db.setContext({
    role: 'authenticated',
    'jwt.claims.user_id': user_id
  });

beforeAll(async () => {
  ({ db, teardown } = await getConnections());
  // postgis...
  await db.any(`GRANT EXECUTE ON ALL FUNCTIONS IN SCHEMA public to public;`);
  await initObjects({ objs, db });
  api = {
    public: db.helper(objs.database1.schema_name),
    private: db.helper(objs.database1.private_schema_name)
  };
  const [user1] = await api.public.callAny('register', {
    email: 'pyramation@gmail.com',
    password: 'password'
  });
  objs.enduser1 = user1;
});

afterAll(async () => {
  try {
    await teardown();
  } catch (e) {
    console.log(e);
  }
});

afterEach(async () => {
  try {
    await db.rollback('db');
    await db.commit();
  } catch (e) {
    console.log(e);
  }
});

beforeEach(async () => {
  await db.begin();
  await db.savepoint('db');
  anon();
});

const emailInvite = async (email) => {
  return await db.any(
    `INSERT INTO "${objs.schemas.public}".invites
      ( email )
      VALUES
      ($1) RETURNING *`,
    [email]
  );
};

const blankInvite = async () => {
  return await db.any(
    `INSERT INTO "${objs.schemas.public}".invites
  ( expires_at )
  VALUES
  ( NOW() + interval '1 day' )
  RETURNING *
  `
  );
};

const multipleInvite = async (limit = 3) => {
  return await db.any(
    `INSERT INTO "${objs.schemas.public}".invites
      ( expires_at, multiple, invite_limit )
      VALUES
      ( NOW() + interval '1 day', true, $1 )
      RETURNING *
      `,
    [limit]
  );
};

/*

- [x] limit to one email
- [ ] how to limit the number somebody can invite?
      ** e.g. any new user has 5 invites for an exclusive platform
- [ ] allow more than one person
- [ ] allow never expires (set to 3000 haha)

*/

const go = async (email) => {
  anon();
  const [user] = await api.public.callAny('register', {
    email,
    password: 'password'
  });

  auth(user.user_id);
  const [{ submit_invite_code: used }] = await api.public.callAny(
    'submit_invite_code',
    {
      token: objs.invite.invite_token
    }
  );
  expect(used).toBe(true);
  const confirmed = await api.public.select('claimed_invites', ['*']);
  snap(confirmed);
};

describe('email invites', () => {
  beforeEach(async () => {
    auth(objs.enduser1.user_id);
    const [invite] = await emailInvite('dan@3daet.com');
    snap(invite);
    objs.invite = invite;
  });
  it('signs in and registers token', async () => {
    anon();
    const [user2] = await api.public.callAny('register', {
      email: 'dan@3daet.com',
      password: 'password'
    });
    auth(user2.user_id);
    const [{ submit_invite_code }] = await api.public.callAny(
      'submit_invite_code',
      {
        token: objs.invite.invite_token
      }
    );
    expect(submit_invite_code).toBe(true);
    const confirmed = await api.public.select('claimed_invites', ['*']);
    snap(confirmed);
  });
  it('signs in and registers token with wrong email', async () => {
    anon();
    const [user2] = await api.public.callAny('register', {
      email: 'ceo@3daet.com',
      password: 'password'
    });
    auth(user2.user_id);
    await assertFailureWithTx({
      db,
      async try() {
        await api.public.callAny('submit_invite_code', {
          token: objs.invite.invite_token
        });
      },
      async assert(e) {
        expect(e.message).toEqual('INVITE_EMAIL_NOT_FOUND');
      }
    });
  });
  it('signs in and registers token after its expired', async () => {
    auth(objs.enduser1.user_id);
    await api.public.update(
      'invites',
      {
        expires_at: '1966-01-29 11:29:21.49629+00'
      },
      {
        id: objs.invite.id
      }
    );
    anon();
    const [user2] = await api.public.callAny('register', {
      email: 'dan@3daet.com',
      password: 'password'
    });
    auth(user2.user_id);
    await assertFailureWithTx({
      db,
      async try() {
        await api.public.callAny('submit_invite_code', {
          token: objs.invite.invite_token
        });
      },
      async assert(e) {
        expect(e.message).toEqual('INVITE_NOT_FOUND');
      }
    });
  });
});

describe('single blank invites', () => {
  beforeEach(async () => {
    auth(objs.enduser1.user_id);
    const [invite] = await blankInvite();
    snap(invite);
    objs.invite = invite;
  });
  it('signs in and registers token', async () => {
    anon();
    const [user2] = await api.public.callAny('register', {
      email: 'anyone@3daet.com',
      password: 'password'
    });
    auth(user2.user_id);
    const [{ submit_invite_code }] = await api.public.callAny(
      'submit_invite_code',
      {
        token: objs.invite.invite_token
      }
    );
    expect(submit_invite_code).toBe(true);
    const confirmed = await api.public.select('claimed_invites', ['*']);
    snap(confirmed);

    anon();
    const [user3] = await api.public.callAny('register', {
      email: 'someone@3daet.com',
      password: 'password'
    });
    db.setContext({
      role: 'authenticated',
      'jwt.claims.user_id': user3.user_id
    });

    await assertFailureWithTx({
      db,
      async try() {
        await api.public.callAny('submit_invite_code', {
          token: objs.invite.invite_token
        });
      },
      async assert(e) {
        expect(e.message).toEqual('INVITE_NOT_FOUND');
      }
    });
  });
});

describe('multiple invites', () => {
  beforeEach(async () => {
    auth(objs.enduser1.user_id);
    const [invite] = await multipleInvite();
    snap(invite);
    objs.invite = invite;
  });
  it('signs in and registers token', async () => {
    await go('person1@3daet.com');
    await go('hithere@3daet.com');
    await go('yeaboi@3daet.com');

    postgres();

    const results = await db.any(
      `SELECT * FROM "${objs.schemas.public}".invites`
    );
    snap(results);
  });
  it('hit invite limit', async () => {
    await go('person1@3daet.com');
    await go('hithere@3daet.com');
    await go('yeaboi@3daet.com');

    await assertFailureWithTx({
      db,
      async try() {
        await go('kewl@3daet.com');
      },
      async assert(e) {
        expect(e.message).toEqual('INVITE_LIMIT');
      }
    });

    postgres();

    const results = await db.any(
      `SELECT * FROM "${objs.schemas.public}".invites`
    );
    snap(results);
  });
});
