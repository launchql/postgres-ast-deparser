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

it('create_insert', async () => {
  const [{ create_insert: ast }] = await db.any(
    `select ast_helpers.create_insert( 
      $1::text,
      $2::text,
      $3::text[],
      $4::jsonb
    );`,
    [
      'myschema',
      'mytable',
      ['id', 'value'],
      JSON.stringify([
        [
          {
            A_Const: {
              val: {
                Integer: {
                  ival: 1
                }
              }
            }
          },
          {
            A_Const: {
              val: {
                String: {
                  str: 'yo'
                }
              }
            }
          }
        ],
        [
          {
            A_Const: {
              val: {
                Integer: {
                  ival: 2
                }
              }
            }
          },
          {
            A_Const: {
              val: {
                String: {
                  str: 'yo2'
                }
              }
            }
          }
        ]
      ])
    ]
  );
  const [
    { deparse: result }
  ] = await db.any(`select deparser.deparse( $1::jsonb );`, [ast]);

  expect(result).toMatchSnapshot();
});
