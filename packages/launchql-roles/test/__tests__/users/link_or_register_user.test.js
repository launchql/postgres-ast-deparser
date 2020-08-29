import { getConnections, closeConnections } from '../../utils';

let db, conn;

describe('roles_private.link_or_register_user()', () => {
  beforeEach(async () => {
    ({ db, conn } = await getConnections());
  });
  afterEach(async () => {
    await closeConnections({ db, conn });
  });
  it('creates', async () => {
    const user = await db.one(
      `SELECT * FROM roles_private.link_or_register_user
      ($1::uuid, $2::text, $3::text, $4::json, $5::json)`,
      [
        null,
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
        }
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
  describe('linking accounts', () => {
    let facebook = null;
    beforeEach(async () => {
      facebook = await db.one(
        `SELECT * FROM roles_private.link_or_register_user
        ($1::uuid, $2::text, $3::text, $4::json, $5::json)`,
        [
          null,
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
          }
        ]
      );
    });
    it('links with id', async () => {
      const twitter = await db.one(
        `SELECT * FROM roles_private.link_or_register_user
        ($1::uuid, $2::text, $3::text, $4::json, $5::json)`,
        [
          facebook.id,
          'twitter',
          '1',
          {
            username: 'JohnDoe',
            display_name: 'John Doe',
            email: 'user@gmail.com'
          },
          {
            privateKey: '1234',
            refreshInfo: '1234'
          }
        ]
      );

      expect(facebook.id).toEqual(twitter.id);
    });
    it('links with email', async () => {
      const twitter = await db.one(
        `SELECT * FROM roles_private.link_or_register_user
        ($1::uuid, $2::text, $3::text, $4::json, $5::json)`,
        [
          null,
          'twitter',
          '1',
          {
            username: 'JohnDoe',
            display_name: 'John Doe',
            email: 'user@gmail.com'
          },
          {
            privateKey: '1234',
            refreshInfo: '1234'
          }
        ]
      );

      expect(facebook.id).toEqual(twitter.id);
    });
  });
});
