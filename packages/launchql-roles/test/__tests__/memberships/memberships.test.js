import { closeConnections, createUser, getConnections } from '../../utils';

let db, conn;
let objs = {};

describe('role types', () => {
  beforeEach(async () => {
    ({ db, conn } = await getConnections());
    objs.user1 = await createUser(db);
    objs.user2 = await createUser(db);
    objs.user3 = await createUser(db);
    objs.user4 = await createUser(db);
    conn.setContext({
      role: 'authenticated',
      'jwt.claims.user_id': objs.user1.id
    });
    objs.organization1 = await conn.one(
      'SELECT * FROM roles_public.register_organization($1)',
      ['organization1']
    );
    conn.setContext({
      role: 'authenticated',
      'jwt.claims.user_id': objs.user2.id
    });

    objs.organization2 = await conn.one(
      'SELECT * FROM roles_public.register_organization($1)',
      ['organization2']
    );

    conn.setContext({
      role: 'authenticated',
      'jwt.claims.user_id': objs.user3.id
    });

    objs.organization3 = await conn.one(
      'SELECT * FROM roles_public.register_organization($1)',
      ['organization3']
    );

    conn.setContext({
      role: 'authenticated',
      'jwt.claims.user_id': objs.user1.id
    });

    objs.profiles = await db.many(
      'SELECT * FROM permissions_public.profile'
    );
    objs.profiles = objs.profiles.reduce((m, profile) => {
      m[profile.organization_id] = m[profile.organization_id] || {};
      m[profile.organization_id][profile.name] = profile;
      return m;
    }, {});

  });
  afterEach(async () => {
    await closeConnections({ db, conn });
  });
  it('admin of owned organizations', async () => {
    const roles = await conn.many('SELECT * FROM roles_public.roles');
    const profile = await conn.one(
      'SELECT * FROM roles_public.role_profiles WHERE role_id=$1',
      [objs.organization1.id]
    );
    expect(profile.display_name).toEqual('organization1');
    expect(objs.organization1.username).toEqual('organization1');
    expect(roles.length).toBe(2);

    const memberships = await conn.many(
      'SELECT * FROM roles_public.memberships WHERE group_id=$1',
      [objs.organization1.id]
    );
    expect(memberships.length).toBe(1);
    expect([objs.profiles[objs.organization1.id].Owner.id, objs.profiles[objs.organization1.id].Administrator.id]).toContain(
      memberships[0].profile_id 
    );
  });
  it('cannot grant users to user roles', async () => {
    conn.setContext({
      role: 'authenticated',
      'jwt.claims.user_id': objs.user2.id
    });
    let failed = false;
    try {
      await conn.any(
        'INSERT INTO roles_public.memberships (role_id, group_id) VALUES ($1, $2)',
        [objs.user1.id, objs.user2.id]
      );
    } catch (e) {
      failed = true;
      expect(e.message).toEqual('MEMBERSHIPS_CANNOT_GRANT_USER');
    }
    expect(failed).toBe(true);
  });
  it('can NOT create a memberships that point to another role you do not own', async () => {
    conn.setContext({
      role: 'authenticated',
      'jwt.claims.user_id': objs.user2.id
    });

    let failed = false;
    try {
      await conn.any(
        'INSERT INTO roles_public.memberships (role_id, group_id) VALUES ($1, $2)',
        [objs.user2.id, objs.organization1.id]
      );
    } catch (e) {
      failed = true;
    }

    const { is_member_of: isMember } = await conn.one(
      'SELECT * FROM roles_private.is_member_of($1, $2)',
      [objs.user2.id, objs.organization1.id]
    );

    expect(isMember).toBe(false);
    expect(failed).toBe(true);
  });
  it('can get recursive roles', async () => {
    conn.setContext({
      role: 'authenticated',
      'jwt.claims.user_id': objs.user2.id
    });
    
    await conn.any(
      'INSERT INTO roles_public.memberships (role_id, group_id, profile_id) VALUES ($1, $2, $3)',
      [objs.user1.id, objs.organization2.id, objs.profiles[objs.organization2.id].Contributor.id]
    );
    conn.setContext({
      role: 'authenticated',
      'jwt.claims.user_id': objs.user3.id
    });

    await conn.any(
      'INSERT INTO roles_public.memberships (role_id, group_id, profile_id) VALUES ($1, $2, $3)',
      [objs.user1.id, objs.organization3.id, objs.profiles[objs.organization3.id].Contributor.id]
    );

    const memberships = await db.any('SELECT * FROM roles_public.memberships');
    expect(memberships.length).toBe(5);

    const membershipsOf = await conn.any(
      'SELECT * FROM roles_public.memberships'
    );
    expect(membershipsOf.length).toBe(2);
  });
  describe('objs.user2 and objs.user3 are members of organization', () => {
    beforeEach(async () => {
      const value = await conn.any(
        'INSERT INTO roles_public.memberships (role_id, group_id, profile_id) VALUES ($1, $2, $3)',
        [objs.user2.id, objs.organization1.id, objs.profiles[objs.organization1.id].Contributor.id]
      );
      expect(value).toBeTruthy();
      const { is_member_of: isMember2 } = await conn.one(
        'SELECT * FROM roles_private.is_member_of($1, $2)',
        [objs.user2.id, objs.organization1.id]
      );
      const value2 = await conn.any(
        'INSERT INTO roles_public.memberships (role_id, group_id, profile_id) VALUES ($1, $2, $3)',
        [objs.user3.id, objs.organization1.id, objs.profiles[objs.organization1.id].Contributor.id]
      );
      expect(value2).toBeTruthy();
      const { is_member_of: isMember3 } = await conn.one(
        'SELECT * FROM roles_private.is_member_of($1, $2)',
        [objs.user3.id, objs.organization1.id]
      );
      expect(isMember2).toBe(true);
      expect(isMember3).toBe(true);
    });
    it('admin can grant users to organizations', async () => {
      const members = await conn.many(
        `SELECT * 
          FROM roles_public.memberships m
          JOIN permissions_public.profile p
          ON (m.profile_id = p.id AND m.organization_id = p.organization_id)
          WHERE
            (p.name != 'Administrator' and p.name != 'Owner')
          AND group_id=$1
          `,
        [objs.organization1.id]
      );
      expect(members.length).toBe(2);

      const admins = await conn.many(
        `SELECT *
          FROM roles_public.memberships m
          JOIN permissions_public.profile p
          ON (m.profile_id = p.id AND m.organization_id = p.organization_id)
          WHERE 
            (p.name = 'Administrator' or p.name = 'Owner')
          AND group_id=$1
        `,
        [objs.organization1.id]
      );
      expect(admins.length).toBe(1);
    });
    it('admin can revoke users from organizations', async () => {
      await conn.any(
        'DELETE FROM roles_public.memberships WHERE role_id=$1 AND group_id=$2',
        [objs.user2.id, objs.organization1.id]
      );

      const { is_member_of: isMemberAfter } = await conn.one(
        'SELECT * FROM roles_private.is_member_of($1, $2)',
        [objs.user2.id, objs.organization1.id]
      );
      expect(isMemberAfter).toBe(false);
    });
    it('member can NOT grant users to organizations', async () => {
      conn.setContext({
        role: 'authenticated',
        'jwt.claims.user_id': objs.user2.id
      });
      let failed = true;
      try {
        await conn.any(
          'INSERT INTO roles_public.memberships (role_id, group_id, profile_id) VALUES ($1, $2, $3)',
          [objs.user4.id, objs.organization1.id, objs.profiles[objs.organization1.id].Contributor.id]
        );
      } catch (e) {
        expect(e.message).toEqual(
          'new row violates row-level security policy for table "memberships"'
        );
        failed = true;
      }
      expect(failed).toBe(true);
      const { is_member_of: isMember } = await conn.one(
        'SELECT * FROM roles_private.is_member_of($1, $2)',
        [objs.user4.id, objs.organization1.id]
      );
      expect(isMember).toBe(false);
    });
    it('member can NOT revoke users from organizations', async () => {
      conn.setContext({
        role: 'authenticated',
        'jwt.claims.user_id': objs.user2.id
      });
      let failed = true;
      try {
        await conn.any(
          'DELETE FROM roles_public.memberships WHERE role_id=$1 AND group_id=$2',
          [objs.user3.id, objs.organization1.id]
        );
      } catch (e) {
        expect(e.message).toEqual(
          'new row violates row-level security policy for table "memberships"'
        );
        failed = true;
      }
      expect(failed).toBe(true);

      const { is_member_of: isMemberAfter } = await db.one(
        'SELECT * FROM roles_private.is_member_of($1, $2)',
        [objs.user3.id, objs.organization1.id]
      );

      expect(isMemberAfter).toBe(true);
    });
    it('member can revoke self from organizations', async () => {
      conn.setContext({
        role: 'authenticated',
        'jwt.claims.user_id': objs.user2.id
      });
      await conn.any(
        'DELETE FROM roles_public.memberships WHERE role_id=$1 AND group_id=$2',
        [objs.user2.id, objs.organization1.id]
      );
      const { is_member_of: isMemberAfter } = await conn.one(
        'SELECT * FROM roles_private.is_member_of($1, $2)',
        [objs.user2.id, objs.organization1.id]
      );
      expect(isMemberAfter).toBe(false);
    });
  });
  describe('objs.user1 and objs.user2 are admins of organization', () => {
    beforeEach(async () => {
      await conn.any(
        'INSERT INTO roles_public.memberships (role_id, group_id, profile_id) VALUES ($1, $2, $3)',
        [objs.user2.id, objs.organization1.id, objs.profiles[objs.organization1.id].Owner.id]
      );
      const { is_member_of: isMember } = await conn.one(
        'SELECT * FROM roles_private.is_member_of($1, $2)',
        [objs.user2.id, objs.organization1.id]
      );
      expect(isMember).toBe(true);
    });
    it('admin can grant admins to organizations', async () => {
      const members = await conn.any(
        `SELECT * 
          FROM roles_public.memberships m
          JOIN permissions_public.profile p
          ON (m.profile_id = p.id AND m.organization_id = p.organization_id)
          WHERE
            (p.name != 'Administrator' and p.name != 'Owner')
          AND group_id=$1
          `,
        [objs.organization1.id]
      );
      expect(members.length).toBe(0);

      const admins = await conn.any(
        `SELECT *
          FROM roles_public.memberships m
          JOIN permissions_public.profile p
          ON (m.profile_id = p.id AND m.organization_id = p.organization_id)
          WHERE 
            (p.name = 'Administrator' or p.name = 'Owner')
          AND group_id=$1
        `,
        [objs.organization1.id]
      );

      expect(admins.length).toBe(2);
    });
    it('admin can revoke admins from organizations', async () => {
      conn.setContext({
        role: 'authenticated',
        'jwt.claims.user_id': objs.user2.id
      });

      await conn.any(
        'DELETE FROM roles_public.memberships WHERE role_id=$1 AND group_id=$2',
        [objs.user1.id, objs.organization1.id]
      );

      const { is_member_of: isMemberAfter } = await conn.one(
        'SELECT * FROM roles_private.is_member_of($1, $2)',
        [objs.user1.id, objs.organization1.id]
      );
      expect(isMemberAfter).toBe(false);
    });
    it('cannot remove last admin from organization', async () => {
      conn.setContext({
        role: 'authenticated',
        'jwt.claims.user_id': objs.user2.id
      });

      await conn.any(
        'DELETE FROM roles_public.memberships WHERE role_id=$1 AND group_id=$2',
        [objs.user1.id, objs.organization1.id]
      );
      let failed = false;

      const { is_member_of: isMemberAfter1 } = await conn.one(
        'SELECT * FROM roles_private.is_member_of($1, $2)',
        [objs.user1.id, objs.organization1.id]
      );
      expect(isMemberAfter1).toBe(false);

      try {
        await conn.any(
          'DELETE FROM roles_public.memberships WHERE role_id=$1 AND group_id=$2',
          [objs.user2.id, objs.organization1.id]
        );
      } catch (e) {
        expect(e.message).toEqual('ORGANIZATIONS_REQUIRE_ONE_OWNER');
        failed = true;
      }

      expect(failed).toBe(true);
      const { is_member_of: isMemberAfter2 } = await conn.one(
        'SELECT * FROM roles_private.is_member_of($1, $2)',
        [objs.user2.id, objs.organization1.id]
      );
      expect(isMemberAfter2).toBe(true);
    });
  });
});
