import { Query } from 'pg-query-string';
import { getConnections } from '../../utils';
import launchql from '../../customers/launchql';

let db, teardown;
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
  query = new Query({ client: db, type: 1 });
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

it('introspects', async () => {
  const [
    { introspect_reset: database_id }
  ] = await db.any(
    'SELECT * FROM collections_private.introspect_reset($1, $2::text[])',
    ['launchql-rls', ['collections_public']]
  );

  console.log(database_id);

  // const schemas = await db.any('SELECT name FROM collections_public.schema');
  // console.log(schemas);
  // const tables = await db.any('SELECT name FROM collections_public.table');
  // console.log(tables);
  // const fields = await db.any(
  //   'SELECT name, type FROM collections_public.field'
  // );
  // console.log(fields);
  // const fields = await db.any(
  //   'SELECT name, type FROM collections_public.primary_key_constraint'
  // );
  // console.log(fields);
  const fkeys = await db.any(
    'SELECT name, type FROM collections_public.foreign_key_constraint'
  );
  console.log(fkeys);
  const uniqs = await db.any(
    'SELECT name, type FROM collections_public.unique_constraint'
  );
  console.log(uniqs);

  await launchql({ database_id, objs, db });

  // TODO ADD RLS to database and table, etc, etc!!!
});
