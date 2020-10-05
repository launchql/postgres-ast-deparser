import { getConnections } from '../../utils';
import { enums } from './__fixtures__/enums';

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
  for (let i = 0; i < enums.length; i++) {
    const [
      { deparse: result }
    ] = await db.any(`select deparser.deparse( $1::jsonb );`, [enums[i]]);
    expect(result).toMatchSnapshot();
  }
});
