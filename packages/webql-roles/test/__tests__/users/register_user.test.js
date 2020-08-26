import { getConnections, closeConnections } from '../../utils';

let db, conn;

describe('roles_private.register_user()', () => {
  beforeEach(async () => {
    ({ db, conn } = await getConnections());
  });
  afterEach(async () => {
    await closeConnections({ db, conn });
  });
  it('roles_private.register_user', async () => {
    const user = await db.one(
      'SELECT * FROM roles_private.register_user($1, $2, $3, $4, $5, $6)',
      [
        'JohnDoe',
        'John Doe',
        'user@gmail.com',
        true,
        'https://avatars1.githubusercontent.com/u/26897230?s=400&u=8064a2d500514cea0bc2c00a6da7e24c8c195841&v=4',
        'awesomepassword'
      ]
    );
    expect(user).toBeTruthy();
    expect(user.id).toBeTruthy();
  });
});
