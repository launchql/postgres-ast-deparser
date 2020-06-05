import { closeConnections, createUser, getConnections } from '../../utils';

let db, conn, user1, user2, organization;

describe('role types', () => {
  beforeEach(async () => {
    ({ db, conn } = await getConnections());

    user1 = await createUser(db);
    user2 = await createUser(db);

    conn.setContext({
      role: 'authenticated',
      'jwt.claims.role_id': user1.id
    });
    organization = await conn.one(
      'SELECT * FROM roles_public.register_organization($1)',
      ['my amazing organization']
    );
  });
  afterEach(async () => {
    await closeConnections({ db, conn });
  });
  it('can update organization', async () => {
    await conn.none(
      'UPDATE roles_public.role_profiles SET display_name=$1 WHERE role_id=$2',
      ['My Team', organization.id]
    );
    const updated = await conn.one(
      'SELECT * FROM roles_public.role_profiles WHERE role_id=$1',
      [organization.id]
    );
    expect(updated.display_name).toEqual('My Team');
  });
  it('cannot update organization type', async () => {
    let failed = false;
    try {
      await conn.none('UPDATE roles_public.roles SET type=$1 WHERE id=$2', [
        'Team',
        organization.id
      ]);
    } catch (e) {
      failed = true;
      expect(e.message).toContain('permission denied');
      expect(e.message).toContain('roles');
    }
    const updated = await conn.one(
      'SELECT * FROM roles_public.roles WHERE id=$1',
      [organization.id]
    );
    expect(failed).toBe(true);
    expect(updated.type).toEqual('Organization');
    expect(updated.updated_at).toEqual(organization.updated_at);
  });
  it('postgres himself cannot update organization type', async () => {
    let failed = false;
    db.setContext({});
    try {
      await db.none('UPDATE roles_public.roles SET type=$1 WHERE id=$2', [
        'Team',
        organization.id
      ]);
    } catch (e) {
      failed = true;
      expect(e.message).toEqual('IMMUTABLE_PROPERTIES');
    }
    const updated = await conn.one(
      'SELECT * FROM roles_public.roles WHERE id=$1',
      [organization.id]
    );
    expect(updated.type).toEqual('Organization');
    expect(failed).toBe(true);
    expect(updated.updated_at).toEqual(organization.updated_at);
  });
  it('not everyone can create a team', async () => {
    let failed = false;
    try {
      conn.setContext({
        role: 'authenticated',
        'jwt.claims.role_id': user2.id
      });
      await conn.one('SELECT * FROM roles_public.register_team($1, $2)', [
        'design team',
        organization.id
      ]);
    } catch (e) {
      failed = true;
      expect(e.message).toEqual(
        'new row violates row-level security policy for table "roles"'
      );
    }
    expect(failed).toBe(true);
  });
  describe('two different orgs', () => {
    let ideo, ideoDesignTeam;
    beforeEach(async () => {
      conn.setContext({
        role: 'authenticated',
        'jwt.claims.role_id': user2.id
      });
      ideo = await conn.one(
        'SELECT * FROM roles_public.register_organization($1)',
        ['IDEO']
      );
      ideoDesignTeam = await conn.one(
        'SELECT * FROM roles_public.register_team($1, $2)',
        ['IDEO design team', ideo.id]
      );
    });
    it('ensure parents are owned', async () => {
      let failed = false;
      try {
        conn.setContext({
          role: 'authenticated',
          'jwt.claims.role_id': user1.id
        });
        await conn.one('SELECT * FROM roles_public.register_team($1, $2, $3)', [
          'secret back door design team',
          ideo.id,
          ideoDesignTeam.id
        ]);
      } catch (e) {
        failed = true;
        expect(e.message).toEqual(
          'new row violates row-level security policy for table "roles"'
        );
      }
      expect(failed).toBe(true);
    });
    it('ensure parents and organizations are in sync', async () => {
      let failed = false;
      try {
        conn.setContext({
          role: 'authenticated',
          'jwt.claims.role_id': user1.id
        });
        await conn.one('SELECT * FROM roles_public.register_team($1, $2, $3)', [
          'secret back door design team',
          organization.id,
          ideoDesignTeam.id
        ]);
      } catch (e) {
        failed = true;
        expect(e.message).toEqual('ORGANIZATION_MISMASTCH');
      }
      expect(failed).toBe(true);
    });
    it('ensure parents and organizations are in sync II', async () => {
      let failed = false;
      try {
        await conn.one('SELECT * FROM roles_public.register_team($1, $2, $3)', [
          'secret back door design team of another organization',
          organization.id,
          ideoDesignTeam.id
        ]);
      } catch (e) {
        failed = true;
        expect(e.message).toEqual('ORGANIZATION_MISMASTCH');
      }
      expect(failed).toBe(true);
    });
  });
});
