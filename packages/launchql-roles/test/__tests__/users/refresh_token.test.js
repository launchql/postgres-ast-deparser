import { getConnections, closeConnections, createUser } from '../../utils';

let db, conn, user;

describe('auth_public.refresh_token()', () => {
  beforeEach(async () => {
    ({ db, conn } = await getConnections());
  });
  beforeEach(async () => {
    user = await createUser(db);
  });
  afterEach(async () => {
    await closeConnections({ db, conn });
  });
  describe('refresh_token logic', () => {
    let token;
    beforeEach(async () => {
      token = await conn.one('SELECT * FROM roles_public.sign_in($1, $2)', [
        user.email,
        user.password
      ]);
      expect(token).toBeTruthy();
      expect(token.role_id).toEqual(user.id);
      expect(token.access_token).toBeTruthy();
      expect(token.refresh_token).toBeTruthy();
    });
    it('refresh_token', async () => {
      const refresh = await conn.one(
        'SELECT * FROM auth_public.refresh_token($1, $2)',
        [token.access_token, token.refresh_token]
      );

      expect(refresh).toBeTruthy();
      expect(refresh.access_token).not.toEqual(token.access_token);
      expect(refresh.refresh_token).toEqual(token.refresh_token);
    });
  });
});
