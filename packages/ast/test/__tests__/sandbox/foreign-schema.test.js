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

it('simple', async () => {
  const [{ deparse: result }] = await db.any(
    `
    select deparser.deparse(
        ast.import_foreign_schema_stmt(
          v_server_name := 'my_fserv',
          v_remote_schema := 'my_rschema',
          v_local_schema := 'my_schema',
          v_list_type := 'FDW_IMPORT_SCHEMA_ALL'
        )
    );`,
    []
  );

  expect(result).toMatchSnapshot();
});

it('with_except', async () => {
  const [{ deparse: result }] = await db.any(
    `
    select deparser.deparse(
        ast.import_foreign_schema_stmt(
          v_server_name := 'my_fserv',
          v_remote_schema := 'my_rschema',
          v_local_schema := 'my_schema',
          v_list_type := 'FDW_IMPORT_SCHEMA_EXCEPT',
          v_table_list := to_jsonb(ARRAY[
            ast.string('table_1'), 
            ast.string('table_2')]
          )
        )
    );`,
    []
  );

  expect(result).toMatchSnapshot();
});

it('with_limit_and_options', async () => {
  const [{ deparse: result }] = await db.any(
    `
    select deparser.deparse(
        ast.import_foreign_schema_stmt(
            v_server_name := 'my_fserv',
            v_remote_schema := 'my_rschema',
            v_local_schema := 'my_schema',
            v_list_type := 'FDW_IMPORT_SCHEMA_LIMIT_TO',
            v_table_list := to_jsonb(ARRAY[
              ast.string('table_1'), 
              ast.string('table_2')]
            ),
            v_options := to_jsonb(ARRAY[
                ast.def_elem(
                    v_defname := 'option_1',
                    v_arg := ast.string('false')
                ),
                ast.def_elem(
                    v_defname := 'option_2',
                    v_arg := ast.string('true')
                )
            ])
        )
    );`,
    []
  );

  expect(result).toMatchSnapshot();
});
