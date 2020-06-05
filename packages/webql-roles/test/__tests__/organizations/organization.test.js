import { getConnections, closeConnections, createUser } from '../../utils';

let db,
  conn,
  objs = {};

describe('Organizations', () => {
  beforeEach(async () => {
    ({ db, conn } = await getConnections());
  });
  beforeEach(async () => {
    objs.user1 = await createUser(db, undefined, 'user1');
    conn.setContext({
      role: 'authenticated',
      'jwt.claims.role_id': objs.user1.id
    });
  });
  afterEach(async () => {
    await closeConnections({ db, conn });
  });
  it('private method', async () => {
    objs.organization1 = await conn.one(
      'SELECT * FROM roles_public.register_organization($1)',
      ['webql']
    );
  });
  it('INSERT', async () => {
    objs.organization1 = await conn.one(
      'INSERT INTO roles_public.organization (username) VALUES ($1) RETURNING *',
      ['webql']
    );
    expect(objs.organization1).toEqual(
      expect.objectContaining({
        type: 'Organization',
        username: 'webql'
      })
    );
  });
  describe('webql organization exists', () => {
    beforeEach(async () => {
      objs.organization1 = await conn.one(
        'INSERT INTO roles_public.organization (username) VALUES ($1) RETURNING *',
        ['webql']
      );
    });
    it('UPDATE', async () => {
      objs.organization1 = await conn.one(
        'UPDATE roles_public.organization SET username=$1 WHERE id=$2 RETURNING *',
        ['skitch', objs.organization1.id]
      );
      expect(objs.organization1).toEqual(
        expect.objectContaining({
          type: 'Organization',
          username: 'skitch'
        })
      );
    });
    it('DELETE', async () => {
      await conn.any('DELETE FROM roles_public.organization WHERE id=$1', [
        objs.organization1.id
      ]);
      const results = await conn.any('SELECT * FROM roles_public.organization');
      expect(results.length).toBe(0);
    });
  });
});
