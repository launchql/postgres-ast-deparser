import { Schema, Query } from 'pg-query-string';
import { getConnections } from '../../utils';
import initDashboardEarth from '../../customers/dashboard';
import { snap } from '../../utils/snaps';
import { USER_SETTINGS_TABLE } from '../../customers/dashboard';

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
  await initDashboardEarth({ objs, db });
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
    // await db.rollback('db');
    await db.commit();
    // await teardown();
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
  const [user2] = await api.public.callAny('register', {
    email: 'gaya@dashboard.earth',
    password: 'password'
  });
  const [user3] = await api.public.callAny('register', {
    email: 'stephen@dashboard.earth',
    password: 'password'
  });
  await api.public.callAny('register', {
    email: 'joris@dashboard.earth',
    password: 'password'
  });
  objs.enduser1 = user1;
  objs.enduser2 = user2;
  objs.enduser3 = user3;
  snap(objs.enduser1);
  snap(objs.enduser2);
  snap(objs.enduser3);
});

it('set lat/lng', async () => {
  db.setContext({
    role: 'authenticated',
    'jwt.claims.user_id': objs.enduser2.user_id
  });
  const q = `INSERT INTO "${objs.database1.schema_name}".user_settings
    (user_id, location)
    VALUES
    ($1, 
      ST_SETSRID(
      POINT($2, $3)::geometry
      , 4326))
   RETURNING *`;
  const res = await db.one(q, [objs.enduser2.user_id, 118.4695, 33.985]);
  snap(res);
});

it('get settings', async () => {
  db.setContext({
    role: 'authenticated',
    'jwt.claims.user_id': objs.enduser2.user_id
  });
  const settings = await query.query(
    qString.public.table(USER_SETTINGS_TABLE).select(['*'], {
      user_id: objs.enduser2.user_id
    })
  );
  snap(settings);
});
it('create actions with tags', async () => {
  db.setContext({
    role: 'authenticated',
    'jwt.claims.user_id': objs.enduser1.user_id
  });
  const results = await query.query(
    qString.public.table('actions', { tags: 'text[]' }).insert({
      owner_id: objs.enduser1.user_id,
      slug: 'my action',
      title: 'My Action',
      description: 'here is the action you wanted',
      tags: ['apples', 'oranges']
    })
  );
  snap(results);
});
it('create actions without tags', async () => {
  db.setContext({
    role: 'authenticated',
    'jwt.claims.user_id': objs.enduser1.user_id
  });
  const results = await query.query(
    qString.public.table('actions', { tags: 'text[]' }).insert({
      owner_id: objs.enduser1.user_id,
      slug: 'heaven is here',
      title: 'take a step',
      description: 'cheers to the future'
    })
  );
  snap(results);
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
