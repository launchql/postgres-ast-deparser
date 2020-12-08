import { Schema, Query } from 'pg-query-string';
import { getConnections } from '../../utils';
import initObjects from '../../utils/generic';
import { assertFailureWithTx } from '../../utils/assertions';
import { snap } from '../../utils/snaps';
import { USER_EMAILS_TABLE, object_key_id } from '../../utils/generic';

let db, api, teardown;
const objs = {
  tables: {}
};

let qString;
let query;

beforeAll(async () => {
  ({ db, teardown } = await getConnections());
  await db.begin();
  await db.savepoint('db');
  // postgis...
  await db.any(`GRANT EXECUTE ON ALL FUNCTIONS IN SCHEMA public to public;`);
  await initObjects({ objs, db });
  query = new Query({ client: db, type: 1 });
  api = {
    public: db.helper(objs.database1.schema_name),
    private: db.helper(objs.database1.private_schema_name)
  };
  qString = {
    public: new Schema(objs.database1.schema_name),
    private: new Schema(objs.database1.private_schema_name)
  };
});

afterAll(async () => {
  try {
    await db.rollback('db');
    await db.commit();
    await teardown();
  } catch (e) {
    console.log(e);
  }
});

beforeEach(async () => {
  db.setContext({
    role: 'anonymous'
  });
});

it('register user', async () => {
  const [user1] = await api.public.callAny('register', {
    email: 'pyramation@gmail.com',
    password: 'password'
  });
  await api.public.callAny('register', {
    email: 'd@nlynch.com',
    password: 'password'
  });
  objs.enduser1 = user1;
  snap(objs.enduser1);
});
it('email exists', async () => {
  db.setContext({
    role: 'authenticated',
    'jwt.claims.user_id': objs.enduser1.user_id
  });
  const emailq = qString.public.table(USER_EMAILS_TABLE).select(['*'], {
    [object_key_id]: objs.enduser1.user_id
  });

  const res = await db.any(emailq.text, emailq.values);
  snap(res);
});
it('account exists', async () => {
  await assertFailureWithTx({
    db,
    async try() {
      await api.public.callAny('register', {
        email: 'pyramation@gmail.com',
        password: 'password'
      });
    },
    async assert(e) {
      expect(e.message).toEqual('ACCOUNT_EXISTS');
    }
  });
});
it('login', async () => {
  db.setContext({
    role: 'anonymous'
  });
  const token = await api.public.callAny('login', {
    email: 'pyramation@gmail.com',
    password: 'password'
  });
  snap(token);
});
it('login attempts', async () => {
  db.setContext({
    role: 'anonymous'
  });
  await assertFailureWithTx({
    db,
    async try() {
      // NOTE: the reason it is max + 1, is because it errors
      // outs after the number of attempts... (apparently)
      for (let i = 0; i < 11; i++) {
        await api.public.callAny('login', {
          email: 'pyramation@gmail.com',
          password: 'badpassword'
        });
      }
    },
    async assert(e) {
      expect(e.message).toEqual('ACCOUNT_LOCKED_EXCEED_ATTEMPTS');
    }
  });
});
