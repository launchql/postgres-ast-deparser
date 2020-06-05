import { getConnections, closeConnections } from '../../utils';

let db, conn;

describe('auth_private.token', () => {
  beforeEach(async () => {
    ({ db, conn } = await getConnections());
  });
  afterEach(async () => {
    await closeConnections({ db, conn });
  });
  it('APP_USER not allowed', async () => {
    let failed = false;
    try {
      await conn.any('SELECT * FROM auth_private.token');
    } catch (e) {
      expect(e.message).toContain('permission denied');
      expect(e.message).toContain('token');
      failed = true;
    }
    expect(failed).toBe(true);
  });
  it('postgres user allowed', async () => {
    let failed = false;
    try {
      await db.any('SELECT * FROM auth_private.token');
    } catch (e) {
      failed = true;
      console.error(e);
    }
    expect(failed).toBe(false);
  });
});
