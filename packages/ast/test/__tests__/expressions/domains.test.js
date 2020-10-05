import { getConnections } from '../../utils';
import { domains } from './__fixtures__/domains';

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

// it('deparse', async () => {
//   const [
//     { deparse: result }
//   ] = await db.any(`select deparser.deparse( $1::jsonb );`, [domains[4]]);
//   expect(result).toMatchSnapshot();
// });

it('deparse', async () => {
  for (let i = 0; i < domains.length; i++) {
    const [
      { deparse: result }
    ] = await db.any(`select deparser.deparse( $1::jsonb );`, [domains[i]]);
    expect(result).toMatchSnapshot();
  }
});
