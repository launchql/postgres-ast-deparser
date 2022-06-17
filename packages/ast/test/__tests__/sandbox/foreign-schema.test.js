import { getConnections } from '../../utils';

let db, teardown;
const objs = {
  tables: {}
};

beforeAll(async () => {
  ({ db, teardown } = await getConnections());
  await db.begin();
  await db.savepoint();
});
afterAll(async () => {
  try {
    //try catch here allows us to see the sql parsing issues!
    await db.rollback();
    await db.commit();
    await teardown();
  } catch (e) {}
});

it('empty', async () => {
  const [{ deparse: result }] = await db.any(
    `
    select deparser.deparse(
        ast.import_foreign_schema_stmt(
            v_server_name := 'mssqldb',
            v_remote_schema := 'HumanResources',
            v_local_schema := 'pg_temp',
            v_list_type := 'LIMIT_TO',
            v_table_list := to_jsonb(ARRAY[
              ast.string('Employee'), 
              ast.string('Shift')]
            ),
            v_options := to_jsonb(ARRAY[
                ast.def_elem(
                    v_defname := 'import_default',
                    v_arg := ast.string('false')
                ),
                ast.def_elem(
                    v_defname := 'import_not_null',
                    v_arg := ast.string('true')
                )
            ])
        )
    );`,
    []
  );

  expect(result).toMatchSnapshot();
});
