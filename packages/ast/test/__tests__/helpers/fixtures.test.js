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
    console.log(e);
  }
});

it('fixtures', async () => {
  const [result] = await db.any(
    `
select deparser.deparse( 
  ast_helpers.create_fixture(
    v_schema := 'v_schema_name',
    v_table := 'v_table_name',
    v_cols := '{a,b,c,d,e}',
    v_values := $1::jsonb
  )
);
  `,
    [
      JSON.stringify([
        [
          { type: 'int', value: 1 },
          { type: 'text', value: 'textme' },
          { type: 'float', value: 1.3 },
          { type: 'jsonb', value: '{"a":1}' },
          { type: 'json', value: null },
          { type: 'bool', value: true }
        ],
        [
          { type: 'int', value: 2 },
          { type: 'text', value: 'yolo' },
          { type: 'float', value: 1.3 },
          { type: 'json', value: '{"c":3}' },
          { type: 'jsonb', value: '{"d":4}' },
          { type: 'bool', value: false }
        ]
      ])
    ]
  );
  expect(result).toMatchSnapshot();
});
