import { getConnections } from '../../utils';
import initObjects from '../../utils/generic';
import { assertFailureWithTx } from '../../utils/assertions';
import { snap } from '../../utils/snaps';

let db, api, teardown;
const objs = {
  tables: {}
};

beforeAll(async () => {
  ({ db, teardown } = await getConnections());
  await db.begin();
  await db.savepoint('db');
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
it('small password on register', async () => {
  await assertFailureWithTx({
    db,
    async try() {
      await api.public.callAny('register', {
        email: 'heyo@gmail.com',
        password: 'pas'
      });
    },
    async assert(e) {
      expect(e.message).toEqual('PASSWORD_LEN');
    }
  });
});
it('small set_password', async () => {
  db.setContext({
    role: 'authenticated',
    'jwt.claims.user_id': objs.enduser1.user_id
  });
  await assertFailureWithTx({
    db,
    async try() {
      await api.public.callAny('set_password', {
        current_password: 'yolo',
        new_password: 'sms'
      });
    },
    async assert(e) {
      expect(e.message).toEqual('PASSWORD_LEN');
    }
  });
});
it('bad set_password', async () => {
  db.setContext({
    role: 'authenticated',
    'jwt.claims.user_id': objs.enduser1.user_id
  });
  await assertFailureWithTx({
    db,
    async try() {
      await api.public.callAny('set_password', {
        current_password: 'wrongpassword',
        new_password: 'newpassword'
      });
    },
    async assert(e) {
      expect(e.message).toEqual('INCORRECT_PASSWORD');
    }
  });
});
it('first time set_password', async () => {
  db.setContext({
    role: 'authenticated',
    'jwt.claims.user_id': objs.enduser1.user_id
  });

  // delete secrets...
  await db.any(
    `DELETE FROM "${objs.schemas.encrypted_secrets}".user_encrypted_secrets
      WHERE owner_id=$1 AND name=$2`,
    [objs.enduser1.user_id, 'password_hash']
  );

  // now can be set
  await api.public.callAny('set_password', {
    current_password: null,
    new_password: 'password'
  });
});
it('set_password', async () => {
  db.setContext({
    role: 'authenticated',
    'jwt.claims.user_id': objs.enduser1.user_id
  });
  const results = await api.public.callAny('set_password', {
    current_password: 'password',
    new_password: 'newpassword'
  });
  expect(results).toMatchSnapshot();
  db.setContext({
    role: 'anonymous'
  });
  const [token] = await api.public.callAny('login', {
    email: 'pyramation@gmail.com',
    password: 'newpassword'
  });
  expect(token.access_token).toBeTruthy();
  snap(token);
});
it('forgot_password', async () => {
  db.setContext({
    role: 'anonymous'
  });
  await api.public.callAny('forgot_password', {
    email: 'pyramation@gmail.com'
  });
  db.setContext({
    role: 'postgres'
  });
  const job = await db.one(`
    SELECT * FROM "${objs.schemas.jobs}".jobs
    WHERE task_identifier='user__forgot_password'
    AND payload->>'email' = 'pyramation@gmail.com'
  `);
  snap(job);
  const user_id = job.payload.user_id;
  const token = job.payload.token;
  db.setContext({
    role: 'anonymous'
  });
  for (let i = 0; i < 9; i++) {
    await api.public.callAny('reset_password', {
      user_id,
      reset_token: 'wrongtoken',
      new_password: 'mynewpassword'
    });
  }
  await api.public.callAny('reset_password', {
    user_id,
    reset_token: token,
    new_password: 'mynewpassword'
  });
  db.setContext({
    role: 'anonymous'
  });
  const [apiToken] = await api.public.callAny('login', {
    email: 'pyramation@gmail.com',
    password: 'mynewpassword'
  });
  snap(apiToken);
  expect(apiToken.access_token).toBeTruthy();
});
it('reset_password attempts', async () => {
  db.setContext({
    role: 'anonymous'
  });
  await api.public.callAny('forgot_password', {
    email: 'pyramation@gmail.com'
  });
  db.setContext({
    role: 'postgres'
  });
  const job = await db.one(`
    SELECT * FROM "${objs.schemas.jobs}".jobs
    WHERE task_identifier='user__forgot_password'
    AND payload->>'email' = 'pyramation@gmail.com'
  `);
  snap(job);
  const user_id = job.payload.user_id;
  db.setContext({
    role: 'anonymous'
  });
  await assertFailureWithTx({
    db,
    async try() {
      // NOTE: the reason it is max + 1, is because it errors
      // outs after the number of attempts... (apparently)
      for (let i = 0; i < 11; i++) {
        await api.public.callAny('reset_password', {
          user_id,
          reset_token: 'resetattemptswrong' + i,
          new_password: 'mynewpassword'
        });
      }
    },
    async assert(e) {
      expect(e.message).toEqual('PASSWORD_RESET_LOCKED_EXCEED_ATTEMPTS');
    }
  });
});
