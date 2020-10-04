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

it('create function stmt', async () => {
  const [{ deparse: result }] = await db.any(`
select deparser.deparse( ast.createfunctionstmt(
  -- name
  to_jsonb(ARRAY[ ast.str('schemer'),ast.str('funker') ]),
  -- params
  to_jsonb(ARRAY[
    ast.functionparameter(
      'param0',
      ast.typename( to_jsonb(ARRAY[ast.str('text')]), false ),
      105
    ),
    ast.functionparameter(
      'param1',
      ast.typename( to_jsonb(ARRAY[ast.str('text')]), false ),
      105
    ),
    ast.functionparameter(
      'param2',
      ast.typename( to_jsonb(ARRAY[ast.str('text')]), true ),
      105,
      ast.aconst(ast.null())
    ),
    ast.functionparameter(
      'param3',
      ast.typename( to_jsonb(ARRAY[ast.str('text')]), true ),
      105,
      ast.aconst(ast.null())
    )
  ]::jsonb[]),
  -- return type
  ast.typename( to_jsonb(ARRAY[ast.str('text')]), false ),
  -- options 
  to_jsonb(ARRAY[
    ast.defelem(
      'volatility',
      ast.str('volatile')
    ),
    ast.defelem(
      'language',
      ast.str('plpgsql')
    ),
    ast.defelem(
      'security',
      ast.int(1)
    )
  ]::jsonb[])
))`);
  expect(result).toMatchSnapshot();
});

it('create function ast', async () => {
  const [{ createfunctionstmt: result }] = await db.any(`
select ast.createfunctionstmt(
  -- name
  to_jsonb(ARRAY[ ast.str('schemer'),ast.str('funker') ]),
  -- params
  to_jsonb(ARRAY[
    ast.functionparameter(
      'param1',
      ast.typename( to_jsonb(ARRAY[ast.str('text')]), false ),
      105
    ),
    ast.functionparameter(
      'param2',
      ast.typename( to_jsonb(ARRAY[ast.str('text')]), true ),
      105
      --ast.aconst(ast.null())
    )
  ]::jsonb[]),
  -- return type
  ast.typename( to_jsonb(ARRAY[ast.str('text')]), false ),
  -- options 
  to_jsonb(ARRAY[
    ast.defelem(
      'volatility',
      ast.str('volatile')
    ),
    ast.defelem(
      'language',
      ast.str('plpgsql')
    ),
    ast.defelem(
      'security',
      ast.int(1)
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
    ast.functionparameter(
      'param1',
      ast.typename( to_jsonb(ARRAY[ast.str('text')]), false ),
      105
    ),
    ast.functionparameter(
      'param2',
      ast.typename( to_jsonb(ARRAY[ast.str('text')]), true ),
      105
      --ast.aconst(ast.null())
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
      ast.aconst(ast.null())
    )
  ]::jsonb[]),
  'code here',
  'volatile',
  'plpgsql',
  1
))`);
  expect(result).toMatchSnapshot();
});
