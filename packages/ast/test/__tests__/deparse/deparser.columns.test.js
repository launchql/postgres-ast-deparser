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
  } catch (e) {
    // noop
  }
});

it('alter_table_drop_column', async () => {
  const [{ expression: result }] = await db.any(
    `select deparser.expression(
              ast_helpers.alter_table_drop_column(
                  v_schema_name := 'myschema',
                  v_table_name := 'mytable',
                  v_column_name := 'mycolumn'
              )
           );`
  );
  expect(result).toMatchSnapshot();
});

it('alter_table_add_column', async () => {
  const [{ expression: result }] = await db.any(
    `select deparser.expression(
              ast_helpers.alter_table_add_column(
                  v_schema_name := 'myschema',
                  v_table_name := 'mytable',
                  v_column_name := 'mycolumn',
                  v_column_type := 'int'
                  )
                  );`
  );
  expect(result).toMatchSnapshot();
});

// BUG
// this ends up scoping it as a pg_catalog type! don't do this!
it('alter_table_add_column with complex type as string', async () => {
  const [{ expression: result }] = await db.any(
    `select deparser.expression(
            ast_helpers.alter_table_add_column(
                v_schema_name := 'myschema',
                v_table_name := 'mytable',
                v_column_name := 'mycolumn',
                v_column_type := 'Geometry(Polygon, 4326)'::text
            )
         );`
  );
  expect(result).toMatchSnapshot();
});

it('alter_table_add_column with complex type as jsonb', async () => {
  const [{ expression: result }] = await db.any(
    `select deparser.expression(
            ast_helpers.alter_table_add_column(
                v_schema_name := 'myschema',
                v_table_name := 'mytable',
                v_column_name := 'mycolumn',
                v_column_type := $1::jsonb
            )
         );`,
    [
      JSON.stringify({
        TypeName: {
          names: [
            {
              String: {
                str: 'geometry'
              }
            }
          ],
          typmods: [
            {
              ColumnRef: {
                fields: [
                  {
                    String: {
                      str: 'polygon'
                    }
                  }
                ]
              }
            },
            {
              A_Const: {
                val: {
                  Integer: {
                    ival: 4326
                  }
                }
              }
            }
          ],
          typemod: -1
        }
      })
    ]
  );
  expect(result).toMatchSnapshot();
});

it('alter_table_add_column with complex type as jsonb', async () => {
  const [{ expression: result }] = await db.any(
    `select deparser.expression(
            ast_helpers.alter_table_add_column(
                v_schema_name := 'myschema',
                v_table_name := 'mytable',
                v_column_name := 'mycolumn',
                v_column_type := $1::jsonb
            )
         );`,
    [
      JSON.stringify({
        TypeName: {
          names: [
            {
              String: {
                str: 'pg_catalog'
              }
            },
            {
              String: {
                str: 'int4'
              }
            }
          ],
          typemod: -1
        }
      })
    ]
  );
  expect(result).toMatchSnapshot();
});

it('alter_table_add_column with complex type as jsonb', async () => {
  const [{ expression: result }] = await db.any(
    `select deparser.expression(
            ast_helpers.alter_table_add_column(
                v_schema_name := 'my-schema',
                v_table_name := 'mytable',
                v_column_name := 'my-column',
                v_column_type := $1::jsonb
            )
         );`,
    [
      JSON.stringify({
        TypeName: {
          names: [
            {
              String: {
                str: 'pg_catalog'
              }
            },
            {
              String: {
                str: 'integer'
              }
            }
          ],
          typemod: -1
        }
      })
    ]
  );
  expect(result).toMatchSnapshot();
});

it('alter_table_rename_column', async () => {
  const [{ expression: result }] = await db.any(
    `select deparser.expression(
            ast_helpers.alter_table_rename_column(
                v_schema_name := 'myschema',
                v_table_name := 'mytable',
                v_old_column_name := 'my-column1',
                v_new_column_name := 'mycolumn2'
            )
         );`
  );
  expect(result).toMatchSnapshot();
});

it('alter_table_set_column_data_type', async () => {
  const [{ expression: result }] = await db.any(
    `select deparser.expression(
            ast_helpers.alter_table_set_column_data_type(
                v_schema_name := 'myschema',
                v_table_name := 'mytable',
                v_column_name := 'mycolumn1',
                v_old_column_type := 'othertype',
                v_new_column_type := 'mycustomtype'
            )
         );`
  );
  expect(result).toMatchSnapshot();
});
