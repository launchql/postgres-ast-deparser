import { getConnections } from '../../utils';
import { triggers } from './__fixtures__/triggers';

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

it('create trig stmt', async () => {
  const json = triggers[0];
  const [{ deparse: result }] = await db.any(`
select deparser.deparse( '${JSON.stringify(json)}'::jsonb );
  `);
  expect(result).toMatchSnapshot();
});

it('create_trigger_stmt', async () => {
  const [result] = await db.any(`
select ast.create_trigger_stmt('trigger',
    ast.range_var('schema-name', 'mytable', true, 'p'),
    to_jsonb(ARRAY[ ast.string('tg-schema'),ast.string('tgname') ]),
    true,
    2,
    16,
    ast.a_expr(3, 
        ast.column_ref(
          to_jsonb(ARRAY[ ast.string('old'),ast.string('field-a') ])
        ),
        '=',
        ast.column_ref(
          to_jsonb(ARRAY[ ast.string('new'),ast.string('field-a') ])
        ) 
    )
);
  `);
  expect(result).toMatchSnapshot();
});

it('create_trigger_stmt deparse', async () => {
  const [result] = await db.any(`
select deparser.deparse( 
  ast.create_trigger_stmt('trigger',
    ast.range_var('schema-name', 'mytable', true, 'p'),
    to_jsonb(ARRAY[ ast.string('tg-schema'),ast.string('tgname') ]),
    true,
    2,
    16,
    ast.a_expr(3, 
        ast.column_ref(
          to_jsonb(ARRAY[ ast.string('old'),ast.string('field-a') ])
        ),
        '=',
        ast.column_ref(
          to_jsonb(ARRAY[ ast.string('new'),ast.string('field-a') ])
        ) 
    )
  )
);
  `);
  expect(result).toMatchSnapshot();
});

it('create_trigger_with_fields', async () => {
  const [{ deparse: result }] = await db.any(`
select deparser.deparse( 
  ast_helpers.create_trigger_with_fields(
    'my-trigger',
    'my-schema',
    'my-table',
    'my-tg-fn-schema',
    'my-tg-fn',  
    ARRAY['name', 'description']::text[],
    2,
    4 | 16)
  )`);
  expect(result).toMatchSnapshot();
});

it('create_trigger_with_fields and names wo quotes', async () => {
  const [{ deparse: result }] = await db.any(`
select deparser.deparse( 
  ast_helpers.create_trigger_with_fields(
    'mytrigger',
    'myschema',
    'mytable',
    'mytgfnschema',
    'mytgfn',  
    ARRAY['name', 'description']::text[],
    2,
    4 | 16)
  )`);
  expect(result).toMatchSnapshot();
});
