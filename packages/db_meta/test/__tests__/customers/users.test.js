import { getConnections } from '../../utils';
import init from '../../customers/users';
import { snap } from '../../utils/snaps';

let db, api, teardown;
const objs = {
  tables: {},
  domains: {},
  apis: {},
  sites: {}
};

beforeAll(async () => {
  ({ db, teardown } = await getConnections());
  await db.begin();
  await db.savepoint('db');
  // postgis...
  await db.any(`GRANT EXECUTE ON ALL FUNCTIONS IN SCHEMA public to public;`);
  await init({ objs, db });
  api = {
    public: db.helper(objs.database1.schema_name),
    private: db.helper(objs.database1.private_schema_name)
  };
});

afterAll(async () => {
  try {
    // await db.rollback('db');
    await db.commit();
    // await teardown();
  } catch (e) {
    console.log(e);
  }
});

const auth = () => {
  db.setContext({
    role: 'authenticated',
    'jwt.claims.user_id': objs.enduser1.user_id,
    'jwt.claims.group_ids': '{' + objs.enduser1.user_id + '}'
  });
};

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
  objs.enduser1 = user1;
  snap(objs.enduser1);
});
