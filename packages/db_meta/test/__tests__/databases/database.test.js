import { getConnections, closeConnections } from '../../utils';
import { snapshot } from '../../utils/snaps';

const v4 = require('uuid').v4;

let db, conn, database, teardown, dbs;

beforeAll(async () => {
  ({ db, conn, teardown } = await getConnections());
  dbs = db.helper('collections_public');
  await db.begin();
  await db.savepoint('db-test');
});
afterAll(async () => {
  await db.rollback('db-test');
  await db.commit();
  await teardown();
});

beforeEach(async () => {
  await db.savepoint('db2');
});
afterEach(async () => {
  await db.rollback('db2');
});

it('create db', async () => {
  database = await dbs.insertOne('database', {
    owner_id: '6d47fe3d-0f1f-4e6a-94d6-4b8fa0364320',
    name: 'mydb'
  });
  console.log(database);
  expect(snapshot(database)).toMatchSnapshot();
});
