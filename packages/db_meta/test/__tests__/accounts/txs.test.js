import { getConnections } from '../../utils';
import initObjects from '../../utils/generic';

let db, api, teardown;
const objs = {
  tables: {}
};

let query;

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

it('freeze objects', async () => {
  db.setContext({
    role: 'postgres'
  });
  const ref = await db.one(
    `SELECT * FROM txs_public.ref WHERE database_id=$1`,
    [objs.database1.id]
  );

  // can we fix dates in testing for hash purposes?

  const commit = await db.one(
    `SELECT * FROM txs_public.commit WHERE database_id=$1 AND id=$2`,
    [objs.database1.id, ref.commit_id]
  );

  await db.any(
    `SELECT * FROM objects_private.freeze_objects(
    $1, $2
  )`,
    [objs.database1.id, commit.tree_id]
  );

  // console.log({ tree: commit.tree_id });

  // const all = await db.many(
  //   `SELECT * FROM objects_private.get_all($1::uuid,$2::uuid)`,
  //   [objs.database1.id, commit.tree_id]
  // );
  // console.log(all);
});
