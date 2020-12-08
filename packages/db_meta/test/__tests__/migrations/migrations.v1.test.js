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
it('migrate', async () => {
  const schema_name = objs.database1.schema_name;
  await migrate.callAny('migrate', {
    module: 'create_table',
    database_id: objs.database1.id,
    schema_name,
    table_name: 'my_table'
  });
  await migrate.callAny('migrate', {
    module: 'alter_table_add_column',
    database_id: objs.database1.id,
    schema_name,
    table_name: 'my_table',
    column_name: 'id',
    column_type: 'serial'
  });
  const row = await sup.public.insertOne('my_table');
  console.log(row);

  const create_table = await migrate.selectOne('sql_actions', ['*'], {
    name: 'create_table'
  });
  console.log(create_table);
  const alter_table_add_column = await migrate.selectOne('sql_actions', ['*'], {
    name: 'alter_table_add_column'
  });
  console.log(alter_table_add_column);
});
