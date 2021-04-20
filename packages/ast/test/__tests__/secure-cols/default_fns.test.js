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

const deparse = async (name, vars) => {
  const [{ deparse }] = await db.any(
    `
  SELECT deparser.deparse(
      $1::jsonb
    )`,
    [name, JSON.stringify(vars)]
  );

  return deparse;
};

it('basic', async () => {
  const [{ expressions_array: result }] = await db.any(
    `
      SELECT * FROM deparser.expressions_array(
        ast_helpers.trigger_set_props_stmts(
            v_cols := ARRAY['verified', 'approved'],
            v_values := $1::jsonb
        )
      )`,
    [
      JSON.stringify([
        {
          type: 'int',
          value: 1
        },
        {
          type: 'bool',
          value: true
        }
      ])
    ]
  );

  expect(result).toMatchSnapshot();
});

it('ast', async () => {
  const [{ expressions_array: result }] = await db.any(
    `
      SELECT * FROM deparser.expressions_array(
        ast_helpers.trigger_set_props_stmts(
            v_cols := ARRAY['verified', 'approved'],
            v_values := $1::jsonb
        )
      )`,
    [
      JSON.stringify([
        {
          type: 'int',
          value: 1
        },
        {
          type: 'ast',
          value: {
            FuncCall: {
              funcname: [
                {
                  String: {
                    str: 'func'
                  }
                }
              ]
            }
          }
        }
      ])
    ]
  );

  expect(result).toMatchSnapshot();
});

it('distinct from values', async () => {
  const [{ deparse: result }] = await db.any(
    `
      SELECT * FROM deparser.deparse(
        ast_helpers.trigger_new_distinct_from_values(
            v_cols := ARRAY['verified', 'approved'],
            v_values := $1::jsonb
        )
      )`,
    [
      JSON.stringify([
        {
          type: 'int',
          value: 1
        },
        {
          type: 'ast',
          value: {
            FuncCall: {
              funcname: [
                {
                  String: {
                    str: 'func'
                  }
                }
              ]
            }
          }
        }
      ])
    ]
  );

  expect(result).toMatchSnapshot();
});
