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
  -- name
  to_jsonb(ARRAY[ ast.string('schemer'),ast.string('funker') ]),
  -- params
  to_jsonb(ARRAY[
    ast.function_parameter(
      'param0',
      ast.type_name( to_jsonb(ARRAY[ast.string('text')]), false ),
      105
    ),
    ast.function_parameter(
      'param1',
      ast.type_name( to_jsonb(ARRAY[ast.string('text')]), false ),
      105
    ),
    ast.function_parameter(
      'param2',
      ast.type_name( to_jsonb(ARRAY[ast.string('text')]), true ),
      105,
      ast.a_const(ast.null())
    ),
    ast.function_parameter(
      'param3',
      ast.type_name( to_jsonb(ARRAY[ast.string('text')]), true ),
      105,
      ast.a_const(ast.null())
    )
  ]::jsonb[]),
  -- return type
  ast.type_name( to_jsonb(ARRAY[ast.string('text')]), false ),
  -- options 
  to_jsonb(ARRAY[
    ast.def_elem(
      'volatility',
      ast.string('volatile')
    ),
    ast.def_elem(
      'language',
      ast.string('plpgsql')
    ),
    ast.def_elem(
      'security',
      ast.integer(1)
    )
  ]::jsonb[])
))`);
  expect(result).toMatchSnapshot();
});

it('create_function_stmt ast', async () => {
  const [{ create_function_stmt: result }] = await db.any(`
select ast.create_function_stmt(
  -- name
  to_jsonb(ARRAY[ ast.string('schemer'),ast.string('funker') ]),
  -- params
  to_jsonb(ARRAY[
    ast.function_parameter(
      'param1',
      ast.type_name( to_jsonb(ARRAY[ast.string('text')]), false ),
      105
    ),
    ast.function_parameter(
      'param2',
      ast.type_name( to_jsonb(ARRAY[ast.string('text')]), true ),
      105
      --ast.a_const(ast.null())
    )
  ]::jsonb[]),
  -- return type
  ast.type_name( to_jsonb(ARRAY[ast.string('text')]), false ),
  -- options 
  to_jsonb(ARRAY[
    ast.def_elem(
      'volatility',
      ast.string('volatile')
    ),
    ast.def_elem(
      'language',
      ast.string('plpgsql')
    ),
    ast.def_elem(
      'security',
      ast.integer(1)
    )
  ]::jsonb[])
)`);
  expect(result).toMatchSnapshot();
});

it('create_function', async () => {
  const [{ create_function: result }] = await db.any(`
SELECT ast.create_function(
  'schema',
  'name',
  'text',
  to_jsonb(ARRAY[
    ast.function_parameter(
      'param1',
      ast.type_name( to_jsonb(ARRAY[ast.string('text')]), false ),
      105
    ),
    ast.function_parameter(
      'param2',
      ast.type_name( to_jsonb(ARRAY[ast.string('text')]), true ),
      105
      --ast.a_const(ast.null())
    )
  ]::jsonb[]),
  'code here',
  'volatile',
  'plpgsql',
  1
)`);
  expect(result).toMatchSnapshot();
});

it('create_function deparse', async () => {
  const [{ deparse: result }] = await db.any(`
SELECT deparser.deparse(ast.create_function(
  'schema',
  'name',
  'text',
  to_jsonb(ARRAY[
    ast.simple_param(
      'param1',
      'text'
    ),
    ast.simple_param(
      'active',
      'bool'
    ),
    ast.simple_param(
      'sid',
      'uuid',
      'uuid_generate_v4()'
    ),
    ast.simple_param(
      'description',
      'text',
      'NULL'
    ),
    ast.simple_param(
      'tags',
      'text[]',
      ast.a_const(ast.null())
    )
  ]::jsonb[]),
  'code here',
  'volatile',
  'plpgsql',
  1
))`);
  expect(result).toMatchSnapshot();
});
