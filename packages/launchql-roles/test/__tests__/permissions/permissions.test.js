import { closeConnections, createUser, getConnections } from '../../utils';

let db, conn;

let objs = {};

describe('permissions', () => {
  beforeEach(async () => {
    ({ db, conn } = await getConnections());
    objs.user1 = await createUser(db, undefined, 'user1');
    conn.setContext({
      role: 'authenticated',
      'jwt.claims.user_id': objs.user1.id
    });
    objs.organization1 = await conn.one(
      'SELECT * FROM roles_public.register_organization($1)',
      ['webql']
    );
    objs.permissions = await db.many('SELECT * FROM permissions_public.permission');
    objs.profiles = await db.many('SELECT * FROM permissions_public.profile');
    objs.profiles = objs.profiles.reduce((m, profile) => {
      m[profile.organization_id] = m[profile.organization_id] || {};
      m[profile.organization_id][profile.name] = profile;
      return m;
    }, {});

  });
  afterEach(async () => {
    await closeConnections({ db, conn });
  });
  it('roles', async () => {
    const result = await conn.any(`SELECT pr.name as profile, pm.name as permission FROM permissions_public.profile pr
	JOIN permissions_private.profile_permissions j ON pr.id = j.profile_id
	JOIN permissions_public.permission	pm ON j.permission_id = pm.id;`);
    expect(result).toMatchSnapshot();
  });
});
