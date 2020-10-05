import { getConnections } from '../../utils';
import { intervals } from './__fixtures__/intervals';

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
  select deparser.deparse( '${JSON.stringify(intervals[0])}'::jsonb );
  `);
  expect(result).toMatchSnapshot();
});
