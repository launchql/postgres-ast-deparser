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

it('funccal', async () => {
  const [result] = await db.any(`
select ast.funccall( 'dan' );
  `);
  expect(result).toMatchSnapshot();
});

it('funccal deparse', async () => {
  const [result] = await db.any(`
select deparser.deparse( ast.funccall( 'dan' ));
  `);
  expect(result).toMatchSnapshot();
});

it('set expr', async () => {
  const [result] = await db.any(`
select deparser.deparse( ast.aexpr(0, ast.str('a'), '=', ast.str('b')) );
  `);
  expect(result).toMatchSnapshot();
});

it('typename', async () => {
  const [result] = await db.any(`
select deparser.deparse( ast.typename( to_jsonb(ARRAY[ast.str('text')]) ) );
  `);
  expect(result).toMatchSnapshot();
});

it('typecast', async () => {
  const [result] = await db.any(`
select deparser.deparse( ast.typecast(ast.aconst(ast.null()), ast.typename( to_jsonb(ARRAY[ast.str('text')]), true )) );
  `);
  expect(result).toMatchSnapshot();
});
