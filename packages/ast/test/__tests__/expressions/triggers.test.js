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
select ast.create_trig_stmt(
    v_trigname := 'trigger',
    v_relation := ast.range_var( v_schemaname := 'schema-name', v_relname := 'mytable', v_inh := true, v_relpersistence := 'p'),
    v_funcname := to_jsonb(ARRAY[ ast.string('tg-schema'),ast.string('tgname') ]),
    v_row := true,
    v_timing := 2,
    v_events := 16,
    v_whenClause := ast.a_expr( v_kind := 3, 
        v_lexpr := ast.column_ref(
          to_jsonb(ARRAY[ ast.string('old'),ast.string('field-b') ])
        ),
        v_name := to_jsonb(ARRAY[ast.string('=')]),
        v_rexpr := ast.column_ref(
          to_jsonb(ARRAY[ ast.string('new'),ast.string('field-b') ])
        ) 
    )
);
  `);
  expect(result).toMatchSnapshot();
});

it('create_trigger_stmt deparse', async () => {
  const [result] = await db.any(`
select deparser.deparse( 
  ast.create_trig_stmt(
    v_trigname := 'trigger',
    v_relation := ast.range_var( v_schemaname := 'schema-name', v_relname := 'mytable', v_inh := true, v_relpersistence := 'p'),
    v_funcname := to_jsonb(ARRAY[ ast.string('tg-schema'),ast.string('tgname') ]),
    v_row := true,
    v_timing := 2,
    v_events := 16,
    v_whenClause := ast.a_expr( v_kind := 3, 
        v_lexpr := ast.column_ref(
          to_jsonb(ARRAY[ ast.string('old'),ast.string('field-b') ])
        ),
        v_name := to_jsonb(ARRAY[ast.string('=')]),
        v_rexpr := ast.column_ref(
          to_jsonb(ARRAY[ ast.string('new'),ast.string('field-b') ])
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
