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
SELECT deparser.deparse(ast.create_policy(
  'mypolicy',
  'schemanamed',
  'mytable',
  'authenticated',
  ast.boolexpr(1, to_jsonb(ARRAY[
    ast.aexpr(0,
      ast.columnref(
        to_jsonb(ARRAY[ ast.str('responder_id') ])
      ),
      '=',
      ast.funccall(
        to_jsonb(ARRAY[ ast.str('dbe'), ast.str('get_uid') ]),
        to_jsonb(ARRAY[ ast.str('c'), ast.str('b') ])
      )  
    ),
    ast.aexpr(0,
      ast.columnref(
        to_jsonb(ARRAY[ ast.str('requester_id') ])
      ),
      '=',
      ast.funccall(
        to_jsonb(ARRAY[ ast.str('dbe'), ast.str('get_other_uid') ]),
        to_jsonb(ARRAY[ ast.str('c'), ast.str('b') ])
      )  
    )
  ])),
  'INSERT',
  true
))`);
  expect(result).toMatchSnapshot();
});
