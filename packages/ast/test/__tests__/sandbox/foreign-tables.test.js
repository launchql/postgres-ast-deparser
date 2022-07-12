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

it('create foreign table stmt', async () => {
  const [{ deparse: result }] = await db.any(
    `
    select deparser.deparse(
      ast.create_foreign_table_stmt(
        v_base := ast.create_stmt(
          v_relation := ast.range_var(
            v_schemaname := 'public',
            v_relname := 'foo',
            v_inh := true,
            v_relpersistence := 'p'
          ),
          v_tableElts := to_jsonb(ARRAY[
            ast.column_def(
              v_colname := 'bar',
              v_typeName := ast.type_name(
                v_names := ast_helpers.array_of_strings(
                  'pg_catalog', 'varchar(50)'
                )
              )
            )
          ])
        ),
        v_servername := 'dummy',
        v_options := to_jsonb(ARRAY[
          ast.def_elem(v_defname := 'schema_name', v_arg := ast.string('public')),
          ast.def_elem(v_defname := 'table_name', v_arg := ast.string('foo'))
        ])
      )
    );`,
    []
  );

  expect(result).toMatchSnapshot();
});