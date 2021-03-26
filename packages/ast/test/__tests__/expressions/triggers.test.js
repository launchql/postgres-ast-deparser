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

xit('create_trigger_stmt', async () => {
  const [result] = await db.any(`
select ast.create_trig_stmt(
    v_trigname := 'trigger',
    v_relation := ast.range_var( 
      v_schemaname := 'schema-name',
      v_relname := 'mytable',
      v_inh := true,
      v_relpersistence := 'p'
    ),
    v_funcname := to_jsonb(ARRAY[ ast.string('tg-schema'),ast.string('tgname') ]),
    v_row := true,
    v_timing := 2,
    v_events := 16,
    v_whenClause := ast.a_expr( v_kind := 'AEXPR_DISTINCT', 
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
    v_whenClause := ast.a_expr( v_kind := 'AEXPR_DISTINCT', 
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
  ast_helpers.create_trigger_distinct_fields(
    v_trigger_name := 'my-trigger',
    v_schema_name := 'my-schema',
    v_table_name := 'my-table',
    v_trigger_fn_schema := 'my-tg-fn-schema',
    v_trigger_fn_name := 'my-tg-fn',  
    v_fields := ARRAY['name', 'description']::text[],
    v_timing := 2,
    v_events := 4 | 16)
  )`);
  expect(result).toMatchSnapshot();
});

it('create_trigger_with_fields w params', async () => {
  const [{ deparse: result }] = await db.any(`
select deparser.deparse( 
  ast_helpers.create_trigger_distinct_fields(
    v_trigger_name := 'my-trigger',
    v_schema_name := 'my-schema',
    v_table_name := 'my-table',
    v_trigger_fn_schema := 'my-tg-fn-schema',
    v_trigger_fn_name := 'my-tg-fn',  
    v_fields := ARRAY['name', 'description']::text[],
    v_params := ARRAY['name', 'description']::text[],
    v_timing := 2,
    v_events := 4 | 16)
  )`);
  expect(result).toMatchSnapshot();
});

it('create_trigger_with_fields and names wo quotes', async () => {
  const [{ deparse: result }] = await db.any(`
select deparser.deparse( 
  ast_helpers.create_trigger_distinct_fields(
    v_trigger_name := 'mytrigger',
    v_schema_name := 'myschema',
    v_table_name := 'mytable',
    v_trigger_fn_schema := 'mytgfnschema',
    v_trigger_fn_name := 'mytgfn',  
    v_fields := ARRAY['name', 'description']::text[],
    v_timing := 2,
    v_events := 4 | 16)
  )`);
  expect(result).toMatchSnapshot();
});

it('ast_helpers.create_trigger_distinct_fields', async () => {
  const [{ deparse: result }] = await db.any(`
select deparser.deparse( 
  ast_helpers.create_trigger_distinct_fields(
    v_trigger_name := 'mytrigger',
    v_schema_name := 'myschema',
    v_table_name := 'mytable',
    v_trigger_fn_schema := 'mytgfnschema',
    v_trigger_fn_name := 'mytgfn',  
    v_fields := ARRAY['name', 'description', 'hi']::text[],
    v_timing := 2,
    v_events := 4 | 16)
  )`);
  expect(result).toMatchSnapshot();
});

it('ast_helpers.create_trigger_distinct_fields', async () => {
  const [{ deparse: result }] = await db.any(`
select deparser.deparse( 
  ast_helpers.create_trigger_distinct_fields(
    v_trigger_name := 'mytrigger',
    v_schema_name := 'myschema',
    v_table_name := 'mytable',
    v_trigger_fn_schema := 'mytgfnschema',
    v_trigger_fn_name := 'mytgfn',  
    v_timing := 2,
    v_events := 4 | 16)
  )`);
  expect(result).toMatchSnapshot();
});

it('drop_trigger', async () => {
  const [{ deparse: result }] = await db.any(`
select deparser.deparse( 
  ast_helpers.drop_trigger(
    v_trigger_name := 'mytrigger',
    v_schema_name := 'myschema',
    v_table_name := 'mytable'
    ))`);
  expect(result).toMatchSnapshot();
});

it('create_function trigger', async () => {
  const [{ deparse: result }] = await db.any(`
select deparser.deparse( 
  ast_helpers.create_function(
    v_schema_name := 'v_schema_name'::text,
    v_function_name := 'v_function_name'::text,
    v_type := 'TRIGGER'::text,
    v_parameters := NULL,
    v_body := 'RETURN NEW;'::text,
    v_volatility := 'volatile'::text,
    v_language := 'plpgsql'::text,
    v_security := 0::int
  )
  )`);
  expect(result).toMatchSnapshot();
});

it('create_function trigger', async () => {
  const [{ deparse: result }] = await db.any(
    `
select deparser.deparse( 
  ast_helpers.create_function(
    v_schema_name := 'v_schema_name'::text,
    v_function_name := 'v_function_name'::text,
    v_type := 'TRIGGER'::text,
    v_parameters := NULL,
    
    v_body := deparser.deparse(
        ast.raw_stmt(
          v_stmt := ast_helpers.eq(
              v_lexpr := ast.string('NEW.field'),
              v_rexpr := ast_helpers.tsvector_index($1::jsonb)
          ),
          v_stmt_len := 1
    )) || E'\nRETURN NEW;',
    v_volatility := 'volatile'::text,
    v_language := 'plpgsql'::text,
    v_security := 0::int
  )
  )`,
    [
      JSON.stringify([
        {
          lang: 'pg_catalog.simple',
          field: 'NEW.name',
          weight: 'A'
        },
        {
          lang: 'pg_catalog.english',
          field: 'NEW.name',
          weight: 'B'
        },
        {
          lang: 'pg_catalog.english',
          field: 'NEW.tags',
          weight: 'C',
          type: 'citext',
          array: true
        },
        {
          lang: 'pg_catalog.english',
          field: 'NEW.sub_head',
          weight: 'B'
        }
      ])
    ]
  );
  expect(result).toMatchSnapshot();
});

it('create_trigger_stmt deparse', async () => {
  const [result] = await db.any(`
select deparser.deparse( 
  ast.create_trig_stmt(
    v_trigname := 'trigger',
    v_relation := ast.range_var( v_schemaname := 'schema-name', v_relname := 'mytable', v_inh := true, v_relpersistence := 'p'),
    v_funcname := to_jsonb(ARRAY[ ast.string('tg-schema'),ast.string('tgname') ]),
    v_args := to_jsonb(ARRAY[ ast.string('tg-schema'),ast.string('tgname') ]),
    v_row := true,
    v_timing := 2,
    v_events := 16,
    v_whenClause := ast.a_expr( v_kind := 'AEXPR_DISTINCT', 
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

it('create_trigger_distinct_fields deparse', async () => {
  const [result] = await db.any(`
select deparser.deparse( 
  ast_helpers.create_trigger_distinct_fields(
    v_trigger_name := 'v_trigger_name',
    
    v_schema_name := 'v_schema_name',
    v_table_name := 'v_table_name',

    v_trigger_fn_schema := 'v_trigger_fn_schema',
    v_trigger_fn_name := 'v_trigger_fn_name',

    v_fields := ARRAY['field1', 'field2'],
    v_params := NULL,
    v_timing := 2,
    v_events := 4
  )
);
  `);
  expect(result).toMatchSnapshot();
});

it('create_trigger deparse', async () => {
  const [result] = await db.any(`
select deparser.deparse( 
  ast_helpers.create_trigger(
    v_trigger_name := 'v_trigger_name',
    
    v_schema_name := 'v_schema_name',
    v_table_name := 'v_table_name',

    v_trigger_fn_schema := 'v_trigger_fn_schema',
    v_trigger_fn_name := 'v_trigger_fn_name',

    v_whenClause := ast_helpers.neq(
      v_lexpr := ast_helpers.col('new', 'type'),
      v_rexpr := ast.a_const( v_val := ast.integer(0) )
    ),
    v_params := NULL,
    v_timing := 2,
    v_events := 4
  )
);
  `);
  expect(result).toMatchSnapshot();
});
