import { getConnections } from '../../utils';
import a_expr7 from './__fixtures__/a_expr.7';
import a_expr8 from './__fixtures__/a_expr.8';
import a_expr9 from './__fixtures__/a_expr.9';
import a_expr10 from './__fixtures__/a_expr.10';
import a_expr10a from './__fixtures__/a_expr.10.a';
import a_expr11 from './__fixtures__/a_expr.11';
import a_expr12 from './__fixtures__/a_expr.12';

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
  await db.rollback();
  await db.commit();
  await teardown();
});
it('expressions', async () => {
  const ast = db.helper('ast');
  const deparser = db.helper('deparser');

  async function testcase(expr) {
    const parseExpr = await deparser.callOne(
      'deparse',
      { expr },
      {
        expr: 'jsonb'
      }
    );
    expect(parseExpr).toMatchSnapshot();
  }

  await testcase(a_expr7);
  await testcase(a_expr8);
  await testcase(a_expr9);
  await testcase(a_expr10);
  await testcase(a_expr10a);
  await testcase(a_expr11);
  await testcase(a_expr12);
});
