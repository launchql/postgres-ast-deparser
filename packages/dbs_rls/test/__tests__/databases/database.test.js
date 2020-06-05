import {
  getConnections,
  closeConnections,
} from '../../utils';

const v4 = require('uuid').v4;

let db, conn, database;

describe('databases', () => {
  beforeEach(async () => {
    ({ db, conn } = await getConnections());
  });
  afterEach(async () => {
    await closeConnections({ db, conn });
  });
  describe('has a database', () => {
    it('works', async () => {
      [database] = await db.any(
        'insert into collections_public.database (tenant_id, name) values ($1, \'mydb\') RETURNING *',
        v4()
      );
      expect(database).toBeTruthy();
    });
  });
});
