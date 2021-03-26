import { getConnections } from '../../utils';
import { functions } from './__fixtures__/functions';

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

it('createfunction stmt from json', async () => {
  const json = functions[0];
  const [{ deparse: result }] = await db.any(`
select deparser.deparse( '${JSON.stringify(json)}'::jsonb );
  `);
  expect(result).toMatchSnapshot();
});

it('create_function_stmt', async () => {
  const [{ deparse: result }] = await db.any(`
select deparser.deparse( ast.create_function_stmt(
  v_funcname := to_jsonb(ARRAY[ ast.string('schemer'),ast.string('funker') ]),
  v_parameters := to_jsonb(ARRAY[
    ast.function_parameter(
      v_name := 'param0',
      v_argType := ast.type_name( 
        v_names := to_jsonb(ARRAY[ast.string('text')])
      ),
      v_mode := 'FUNC_PARAM_IN'
    ),
    ast.function_parameter(
      v_name := 'param1',
      v_argType := ast.type_name( 
        v_names := to_jsonb(ARRAY[ast.string('text')])
      ),
      v_mode := 'FUNC_PARAM_IN'
    ),
    ast.function_parameter(
      v_name := 'param2',
      v_argType := ast.type_name( 
        v_names := to_jsonb(ARRAY[ast.string('text')]),
        v_arrayBounds := to_jsonb(ARRAY[ast.integer(-1)])
      ),
      v_mode := 'FUNC_PARAM_IN',
      v_defexpr := ast.a_const(ast.null())
    ),
    ast.function_parameter(
      v_name := 'param3',
      v_argType := ast.type_name( 
        v_names := to_jsonb(ARRAY[ast.string('text')]),
        v_arrayBounds := to_jsonb(ARRAY[ast.integer(-1)])
      ),
      v_mode := 'FUNC_PARAM_IN',
      v_defexpr := ast.a_const(ast.null())
    )
  ]::jsonb[]),
  
  v_returnType := ast.type_name( 
    v_names := to_jsonb(ARRAY[ast.string('text')])
  ),

  v_options := to_jsonb(ARRAY[
    ast.def_elem(
      v_defname := 'volatility',
      v_arg := ast.string('volatile')
    ),
    ast.def_elem(
      v_defname := 'language',
      v_arg := ast.string('plpgsql')
    ),
    ast.def_elem(
      v_defname := 'security',
      v_arg := ast.integer(1)
    )
  ]::jsonb[])
))`);
  expect(result).toMatchSnapshot();
});

it('create_function_stmt ast', async () => {
  const [{ create_function_stmt: result }] = await db.any(`
select ast.create_function_stmt(
  v_funcname := to_jsonb(ARRAY[ ast.string('schemer'),ast.string('funker') ]),
  v_parameters := to_jsonb(ARRAY[
    ast.function_parameter(
      v_name := 'param1',
      v_argType := ast.type_name( 
        v_names := to_jsonb(ARRAY[ast.string('text')])
      ),
      v_mode := 'FUNC_PARAM_IN'
    ),
    ast.function_parameter(
      v_name := 'param2',
      v_argType := ast.type_name( 
        v_names := to_jsonb(ARRAY[ast.string('text')]),
        v_arrayBounds := to_jsonb(ARRAY[ast.integer(-1)])
      ),
      v_mode := 'FUNC_PARAM_IN'
      --ast.a_const(ast.null())
    )
  ]::jsonb[]),

  v_returnType := ast.type_name( 
    v_names := to_jsonb(ARRAY[ast.string('text')])
  ),

  v_options := to_jsonb(ARRAY[
    ast.def_elem(
      v_defname := 'volatility',
      v_arg := ast.string('volatile')
    ),
    ast.def_elem(
      v_defname := 'language',
      v_arg := ast.string('plpgsql')
    ),
    ast.def_elem(
      v_defname := 'security',
      v_arg := ast.integer(1)
    )
  ]::jsonb[])
)`);
  expect(result).toMatchSnapshot();
});

it('create_function', async () => {
  const [{ create_function: result }] = await db.any(`
SELECT ast_helpers.create_function(
  v_schema_name := 'schema',
  v_function_name := 'name',
  v_type := 'text',
  v_parameters := to_jsonb(ARRAY[
    ast.function_parameter(
      v_name := 'param1',
      v_argType := ast.type_name( 
        v_names := to_jsonb(ARRAY[ast.string('text')])
      ),
      v_mode := 'FUNC_PARAM_IN'
    ),
    ast.function_parameter(
      v_name := 'param2',
      v_argType := ast.type_name( 
        v_names := to_jsonb(ARRAY[ast.string('text')]),
        v_arrayBounds := to_jsonb(ARRAY[ast.integer(-1)])
      ),
      v_mode := 'FUNC_PARAM_IN'
      --ast.a_const(ast.null())
    )
  ]::jsonb[]),
  v_body := 'code here',
  v_volatility := 'volatile',
  v_language := 'plpgsql',
  v_security := 1
)`);
  expect(result).toMatchSnapshot();
});

it('create_function deparse', async () => {
  const [{ deparse: result }] = await db.any(`
SELECT deparser.deparse(ast_helpers.create_function(
  v_schema_name := 'schema',
  v_function_name := 'name',
  v_type := 'text',
  v_parameters := to_jsonb(ARRAY[
    ast_helpers.simple_param(
      'param1',
      'text'
    ),
    ast_helpers.simple_param(
      'active',
      'bool'
    ),
    ast_helpers.simple_param(
      'sid',
      'uuid',
      'uuid_generate_v4()'
    ),
    ast_helpers.simple_param(
      'description',
      'text',
      'NULL'
    ),
    ast_helpers.simple_param(
      'tags',
      'text[]',
      ast.a_const(ast.null())
    )
  ]::jsonb[]),
  v_body := 'code here',
  v_volatility := 'volatile',
  v_language := 'plpgsql',
  v_security := 1
))`);
  expect(result).toMatchSnapshot();
});

it('create_trigger deparse', async () => {
  const [{ deparse: result }] = await db.any(`
SELECT deparser.deparse(ast_helpers.create_function(
  v_schema_name := 'schema',
  v_function_name := 'name',
  v_type := 'TRIGGER',
  v_parameters := to_jsonb(ARRAY[
    ast_helpers.simple_param(
      'param1',
      'text'
    ),
    ast_helpers.simple_param(
      'active',
      'bool'
    ),
    ast_helpers.simple_param(
      'sid',
      'uuid',
      'uuid_generate_v4()'
    ),
    ast_helpers.simple_param(
      'description',
      'text',
      'NULL'
    ),
    ast_helpers.simple_param(
      'tags',
      'text[]',
      ast.a_const(ast.null())
    )
  ]::jsonb[]),
  v_body := 'code here',
  v_volatility := 'volatile',
  v_language := 'plpgsql',
  v_security := 0
))`);
  expect(result).toMatchSnapshot();
});

it('drop deparse', async () => {
  const [{ deparse: result }] = await db.any(`
SELECT deparser.deparse(ast_helpers.drop_function(
  v_schema_name := 'schema',
  v_function_name := 'name'
))`);
  expect(result).toMatchSnapshot();
});
