import {
  getConnections,
  closeConnections,
} from '../../utils';

import {
  twoUsersAndProject
} from '../../utils/projects';

let db, conn;
let objs = {};

describe('databases', () => {
  beforeEach(async () => {
    ({ db, conn } = await getConnections());
    await twoUsersAndProject({ db, conn, objs });
  });
  afterEach(async () => {
    await closeConnections({ db, conn });
  });
  describe('has database privs', () => {
    it('works', async () => {
      const [database] = await conn.any(
        'insert into collections_public.database (project_id, name) values ($1, \'mydb\') RETURNING *',
        objs.project1.id
      );
      expect(database).toBeTruthy();
    });
  });
  describe('has no database privs', () => {
    it('fails', async () => {
      let failed = false;
      conn.setContext({
        role: 'authenticated',
        'jwt.claims.role_id': objs.user2.id
      });

      try {
        await conn.any(
          'insert into collections_public.database (project_id, name) values ($1, \'mydb\') RETURNING *',
          objs.project1.id
        );
      } catch (e) {
        failed = true;
      }
      expect(failed).toBe(true);
    });
  });
});
