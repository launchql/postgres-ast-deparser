import { getConnections, closeConnections, createUser } from '../../utils';

let db, conn, user;

describe('auth_public.create_service_token()', () => {
  beforeEach(async () => {
    ({ db, conn } = await getConnections());
  });
  beforeEach(async () => {
    user = await createUser(db);
    conn.setContext({
      role: 'authenticated',
      'jwt.claims.user_id': user.id
    });
  });
  afterEach(async () => {
    await closeConnections({ db, conn });
  });
  describe('service_token logic', () => {
    it('service_token', async () => {
      const [serviceToken] = await conn.any(
        'SELECT * FROM auth_public.create_service_token()',
        []
      );
      expect(serviceToken).toBeTruthy();
      expect(serviceToken.access_token).toBeTruthy();
      expect(serviceToken.refresh_token).toBeFalsy();
    });
  });
});
