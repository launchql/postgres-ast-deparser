import { getConnections, closeConnections } from '../../utils';

let db, conn;

describe('roles_private.register_auth_role()', () => {
  beforeEach(async () => {
    ({ db, conn } = await getConnections());
  });
  afterEach(async () => {
    await closeConnections({ db, conn });
  });
  it('roles_private.register_auth_role', async () => {
    const user = await db.one(
      'SELECT * FROM roles_private.register_auth_role($1, $2, $3::json, $4::json, $5)',
      [
        'facebook',
        '1',
        {
          username: 'JohnDoe',
          display_name: 'John Doe',
          email: 'user@gmail.com'
        },
        {
          privateKey: '1234',
          refreshInfo: '1234'
        },
        true
      ]
    );
    expect(user).toBeTruthy();
    expect(user.id).toBeTruthy();

    const user_authentication = await db.one(
      'SELECT * FROM auth_public.user_authentications WHERE role_id=$1',
      [user.id]
    );
    expect(user_authentication).toBeTruthy();
    expect(user_authentication.service).toEqual('facebook');
    expect(user_authentication.identifier).toEqual('1');
    expect(user_authentication.details).toEqual({
      username: 'JohnDoe',
      display_name: 'John Doe',
      email: 'user@gmail.com'
    });

    const user_authentication_secrets = await db.one(
      'SELECT * FROM auth_private.user_authentication_secrets WHERE user_authentication_id=$1',
      [user_authentication.id]
    );

    expect(user_authentication_secrets).toBeTruthy();
    expect(user_authentication_secrets.details).toBeTruthy();
    expect(user_authentication_secrets.details).toEqual({
      privateKey: '1234',
      refreshInfo: '1234'
    });
  });
  it('less info', async () => {
    const user = await db.one(
      'SELECT * FROM roles_private.register_auth_role($1, $2, $3::json, $4::json, $5)',
      [
        'facebook',
        '1',
        {
          display_name: 'John Doe',
          email: 'user@gmail.com'
        },
        {
          privateKey: '1234',
          refreshInfo: '1234'
        },
        true
      ]
    );
    expect(user).toBeTruthy();
    expect(user.id).toBeTruthy();
  });
  describe('has user', () => {
    let user = null;
    let token = null;
    beforeEach(async () => {
      user = await db.one(
        'SELECT * FROM roles_private.register_auth_role($1, $2, $3::json, $4::json, $5)',
        [
          'facebook',
          '1',
          {
            display_name: 'John Doe',
            email: 'user@gmail.com'
          },
          {
            privateKey: '1234',
            refreshInfo: '1234'
          },
          true
        ]
      );

      expect(user).toBeTruthy();
      expect(user.id).toBeTruthy();

      token = await db.one(
        'SELECT * FROM roles_private.service_sign_in($1,$2)',
        [user.id, 'facebook']
      );
    });
    it('has a token for login', async () => {
      expect(token).toBeTruthy();
      expect(token.id).toBeTruthy();
      expect(token.access_token).toBeTruthy();
      expect(token.access_token_expires_at).toBeTruthy();
    });
    it('delete a user and everything is gone', async () => {
      await db.any('DELETE FROM roles_public.roles WHERE id = $1', [user.id]);

      const tokensAfter = await db.any(
        'SELECT * FROM auth_private.token WHERE role_id=$1',
        [user.id]
      );

      expect(tokensAfter.length).toBe(0);
    });
  });
});
