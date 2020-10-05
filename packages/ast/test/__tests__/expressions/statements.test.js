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

it('func_call', async () => {
  const [result] = await db.any(`
select ast.func_call( 'dan' );
  `);
  expect(result).toMatchSnapshot();
});

it('func_call deparse', async () => {
  const [result] = await db.any(`
select deparser.deparse( ast.func_call( 'dan' ));
  `);
  expect(result).toMatchSnapshot();
});

it('a_expr', async () => {
  const [result] = await db.any(`
select deparser.deparse( ast.a_expr(0, ast.string('a'), '=', ast.string('b')) );
  `);
  expect(result).toMatchSnapshot();
});

it('type_name', async () => {
  const [result] = await db.any(`
select deparser.deparse( ast.type_name( to_jsonb(ARRAY[ast.string('text')]) ) );
  `);
  expect(result).toMatchSnapshot();
});

it('type_cast', async () => {
  const [result] = await db.any(`
select deparser.deparse( ast.type_cast(ast.a_const(ast.null()), ast.type_name( to_jsonb(ARRAY[ast.string('text')]), true )) );
  `);
  expect(result).toMatchSnapshot();
});
