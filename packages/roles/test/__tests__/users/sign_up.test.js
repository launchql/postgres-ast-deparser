import { getConnections, closeConnections } from '../../utils';

let db, conn;

describe('roles_public.sign_up()', () => {
  beforeEach(async () => {
    ({ db, conn } = await getConnections());
  });
  afterEach(async () => {
    await closeConnections({ db, conn });
  });
  it('sign_up', async () => {
    const token = await conn.one(
      'SELECT * FROM roles_public.sign_up($1, $2, $3)',
      ['John Doe', 'user@gmail.com', 'awesomepassword']
    );
    const user = await db.one(
      'SELECT * FROM roles_public.roles WHERE id=$1',
      [token.role_id]
    );

    expect(user.id).toBeTruthy();
    expect(user.username).toEqual('John_Doe');
  });
  it('picks a username', async () => {
    await conn.one('SELECT * FROM roles_public.sign_up($1, $2, $3)', [
      'john doe',
      'user@gmail.com',
      'awesomepassword'
    ]);

    const token = await conn.one(
      'SELECT * FROM roles_public.sign_up($1, $2, $3)',
      ['John Doe', 'user2@gmail.com', 'awesomepassword']
    );
    const user = await db.one(
      'SELECT * FROM roles_public.roles WHERE id=$1',
      [token.role_id]
    );

    expect(user.id).toBeTruthy();
    expect(user.username).toEqual('John_Doe1');
  });
});
