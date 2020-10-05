import { getConnections } from '../../utils';
import { policies } from './__fixtures__/policies';

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

it('deparse', async () => {
  const [{ deparse: result }] = await db.any(`
  select deparser.deparse( '${JSON.stringify(policies[0])}'::jsonb );
  `);
  expect(result).toMatchSnapshot();
});

it('policy deparse', async () => {
  const result = await db.any(`
SELECT deparser.deparse(ast_helpers.create_policy(
  'mypolicy',
  'schemanamed',
  'mytable',
  'authenticated',
  ast.bool_expr(1, to_jsonb(ARRAY[
    ast.a_expr(0,
      ast.column_ref(
        to_jsonb(ARRAY[ ast.string('responder_id') ])
      ),
      '=',
      ast.func_call(
        to_jsonb(ARRAY[ ast.string('dbe'), ast.string('get_uid') ]),
        to_jsonb(ARRAY[ ast.string('c'), ast.string('b') ])
      )  
    ),
    ast.a_expr(0,
      ast.column_ref(
        to_jsonb(ARRAY[ ast.string('requester_id') ])
      ),
      '=',
      ast.func_call(
        to_jsonb(ARRAY[ ast.string('dbe'), ast.string('get_other_uid') ]),
        to_jsonb(ARRAY[ ast.string('c'), ast.string('b') ])
      )  
    )
  ])),
  'INSERT',
  true
))`);
  expect(result).toMatchSnapshot();
});
