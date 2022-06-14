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

it('with fields', async () => {
  const [{ deparse: result }] = await db.any(
    `
    select deparser.deparse(
        ast_helpers.create_table(
            v_schema_name := 'my_schema_name',
            v_table_name := 'my_table_name',
            v_table_elts := to_jsonb(ARRAY[
                ast.column_def(
                    v_colname := 'my_col_id',
                    v_typeName := ast.type_name(
                        v_names := ast_helpers.array_of_strings('pg_catalog', 'int4')
                    ),
                    v_constraints := to_jsonb(ARRAY[
                        ast.constraint(v_contype := 'CONSTR_PRIMARY'),
                        ast.constraint(v_contype := 'CONSTR_IDENTITY', v_generated_when := 'a')
                    ])
                ),
                ast.column_def(
                    v_colname := 'my_col_text',
                    v_typeName := ast.type_name(
                        v_names := ast_helpers.array_of_strings('text')
                    ),
                    v_constraints := to_jsonb(ARRAY[
                        ast.constraint(v_contype := 'CONSTR_NOTNULL')
                    ])
                ),
                ast.column_def(
                    v_colname := 'my_col_timestamptz',
                    v_typeName := ast.type_name(
                        v_names := ast_helpers.array_of_strings('timestamptz')
                    )
                )
            ])
        )
    );`,
    []
  );

  expect(result).toMatchSnapshot();
});

it('empty', async () => {
  const [{ deparse: result }] = await db.any(
    `
    select deparser.deparse(
        ast_helpers.create_table(
            v_schema_name := 'my_schema_name',
            v_table_name := 'my_table_name'
        )
    );`,
    []
  );

  expect(result).toMatchSnapshot();
});
