import { getConnections } from '../../utils';
import { references } from './__fixtures__/references';

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
  for (let i = 0; i < references.length; i++) {
    const [
      { deparse: result }
    ] = await db.any(`select deparser.deparse( $1::jsonb );`, [references[i]]);
    expect(result).toMatchSnapshot();
  }
});
