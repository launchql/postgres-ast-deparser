import { getConnections } from '../../utils';
import { initDatabase } from '../../utils/helpers';

let db, conn, dbs, admin, api, sup, migrate, teardown;
const objs = {
  tables: {},
  modules: {}
};
beforeAll(async () => {
  ({ db, conn, teardown } = await getConnections());
  await db.begin();
  await db.savepoint();
  dbs = db.helper('collections_public');
  await initDatabase({ objs, dbs, dbname: 'simpledb' });
  admin = {
    public: db.helper('collections_public'),
    private: db.helper('collections_private')
  };
  migrate = db.helper('db_migrate');
  api = {
    public: conn.helper(objs.database1.schema_name),
    private: conn.helper(objs.database1.private_schema_name)
  };
  sup = {
    public: db.helper(objs.database1.schema_name),
    private: db.helper(objs.database1.private_schema_name)
  };
});
afterAll(async () => {
  try {
    await db.rollback();
    await db.commit();
    await teardown();
  } catch (e) {
    console.log(e);
  }
});
// import { Table, Schema } from 'pg-query-string';
// const schema = new Schema('db_migrate');
// const actions = schema.table('sql_actions', {
//   id: 'uuid'
// });

it('migrate', async () => {
  // OTHERWISE REQUIRES YOU HAVE a REPO
  let action;
  await db.any(`SET session_replication_role TO replica;`);
  try {
    [action] = await migrate.insert('sql_actions', {
      database_id: objs.database1.id,
      name: 'dostuff',
      deploy: 'a/b/a',
      content: "RAISE NOTICE 'halo';"
    });
    [action] = await migrate.insert('sql_actions', {
      database_id: objs.database1.id,
      name: 'dostuff',
      deploy: 'a/b/b',
      content: 'SELECT 1;'
    });
    // [action] = await migrate.insert('sql_actions', {
    //   database_id: objs.database1.id,
    //   name: 'dostuff',
    //   deploy: 'a/b/c',
    //   content: "RAISE NOTICE 'halo3';"
    // });
    // [action] = await migrate.insert('sql_actions', {
    //   database_id: objs.database1.id,
    //   name: 'dostuff',
    //   deploy: 'a/b/d',
    //   content: "RAISE NOTICE 'halo4';"
    // });
    console.log(action);
  } catch (e) {
    console.log(e);
  } finally {
    await db.any(`SET session_replication_role TO DEFAULT;`);
  }

  await migrate.call('run_migration', {
    database_id: objs.database1.id,
    id: action.id,
    kind: 'deploy'
  });
});
