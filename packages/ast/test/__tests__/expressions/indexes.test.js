import { getConnections } from '../../utils';
import { indexes } from './__fixtures__/indexes';

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

it('index_stmt', async () => {
    for (const index of indexes) {
      const [{ deparse: result }] = await db.any(
        `
  select deparser.deparse(
    $1::jsonb
  );
    `,
        [index]
      );
      expect(result).toMatchSnapshot();
    }
  });