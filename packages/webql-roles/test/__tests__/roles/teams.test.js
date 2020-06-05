import { closeConnections, createUser, getConnections } from '../../utils';

let db, conn;
let objs = {};
let profiles;

describe('role types', () => {
  beforeEach(async () => {
    ({ db, conn } = await getConnections());
    objs.admin = await createUser(db);
    conn.setContext({
      role: 'authenticated',
      'jwt.claims.role_id': objs.admin.id
    });
    objs.webql = await conn.one(
      'SELECT * FROM roles_public.register_organization($1)',
      ['webql']
    );
    objs.sinai = await conn.one(
      'SELECT * FROM roles_public.register_organization($1)',
      ['sinai']
    );

    profiles = await db.many(
      'SELECT * FROM permissions_public.profile'
    );
    profiles = profiles.reduce((m, profile) => {
      m[profile.organization_id] = m[profile.organization_id] || {};
      m[profile.organization_id][profile.name] = profile;
      return m;
    }, {});


    // design team
    objs.designer = await createUser(db);
    objs.designTeam = await conn.one(
      'SELECT * FROM roles_public.register_team($1, $2)',
      ['design team', objs.sinai.id]
    );
    await conn.any(
      'INSERT INTO roles_public.memberships (role_id, group_id, profile_id, organization_id) VALUES ($1, $2, $3, $4)',
      [objs.designer.id, objs.designTeam.id, profiles[objs.sinai.id].Owner.id, objs.sinai.id]
    );

    // engineering team
    objs.VpEng = await createUser(db);
    objs.developer = await createUser(db);

    objs.engTeam = await conn.one(
      'SELECT * FROM roles_public.register_team($1, $2)',
      ['engineering team', objs.sinai.id]
    );
    await conn.any(
      'INSERT INTO roles_public.memberships (role_id, group_id, profile_id, organization_id) VALUES ($1, $2, $3, $4)',
      [objs.VpEng.id, objs.engTeam.id, profiles[objs.sinai.id].Owner.id, objs.sinai.id]
    );
    await conn.any(
      'INSERT INTO roles_public.memberships (role_id, group_id, profile_id, organization_id) VALUES ($1, $2, $3, $4)',
      [objs.developer.id, objs.engTeam.id, profiles[objs.sinai.id].Contributor.id, objs.sinai.id]
    );

    // qa devs
    objs.qaDev = await createUser(db);
    objs.qaTeam = await conn.one(
      'SELECT * FROM roles_public.register_team($1, $2, $3)',
      ['QA', objs.sinai.id, objs.engTeam.id]
    );
    await conn.any(
      'INSERT INTO roles_public.memberships (role_id, group_id, profile_id, organization_id) VALUES ($1, $2, $3, $4)',
      [objs.qaDev.id, objs.qaTeam.id, profiles[objs.sinai.id].Contributor.id, objs.sinai.id]
    );

    // junior devs
    objs.juniorDev = await createUser(db);
    objs.juniorTeam = await conn.one(
      'SELECT * FROM roles_public.register_team($1, $2, $3)',
      ['junior devs', objs.sinai.id, objs.engTeam.id]
    );
    await conn.any(
      'INSERT INTO roles_public.memberships (role_id, group_id, profile_id, organization_id) VALUES ($1, $2, $3, $4)',
      [objs.juniorDev.id, objs.juniorTeam.id, profiles[objs.sinai.id].Contributor.id, objs.sinai.id]
    );
  });
  afterEach(async () => {
    await closeConnections({ db, conn });
  });
  describe('admin', () => {
    it('sees only n roles', async () => {
      const roles = await conn.many('SELECT * FROM roles_public.roles');
      expect(roles.length).toBe(7);
    });
    it('has all memberships', async () => {
      const teams = [
        objs.engTeam,
        objs.juniorTeam,
        objs.qaTeam,
        objs.designTeam
      ];
      for (let i = 0; i < teams.length; i++) {
        const { is_member_of: isMember } = await db.one(
          'SELECT * FROM roles_private.is_member_of($1, $2)',
          [objs.admin.id, teams[i].id]
        );
        expect(isMember).toBe(true);
      }
    });
    it('has all ownerships', async () => {
      const teams = [
        objs.engTeam,
        objs.juniorTeam,
        objs.qaTeam,
        objs.designTeam
      ];
      for (let i = 0; i < teams.length; i++) {
        const { is_admin_of: isAdmin } = await db.one(
          'SELECT * FROM roles_private.is_admin_of($1, $2)',
          [objs.admin.id, teams[i].id]
        );
        expect(isAdmin).toBe(true);
      }
    });
    it('can add members to any team', async () => {
      await conn.any(
        'INSERT INTO roles_public.memberships (role_id, group_id, profile_id, organization_id) VALUES ($1, $2, $3, $4)',
        [objs.designer.id, objs.qaTeam.id, profiles[objs.sinai.id].Contributor.id, objs.sinai.id]
      );
      const { is_member_of: isMember } = await db.one(
        'SELECT * FROM roles_private.is_member_of($1, $2)',
        [objs.designer.id, objs.qaTeam.id]
      );
      expect(isMember).toBe(true);
    });
    it('can remove members to any team', async () => {
      await conn.any(
        'DELETE FROM roles_public.memberships WHERE role_id=$1 AND group_id=$2 AND organization_id=$3',
        [objs.designer.id, objs.designTeam.id, objs.sinai.id]
      );
      await conn.any(
        'DELETE FROM roles_public.memberships WHERE role_id=$1 AND group_id=$2 AND organization_id=$3',
        [objs.VpEng.id, objs.engTeam.id, objs.sinai.id]
      );
      const { is_member_of: isVpEng } = await db.one(
        'SELECT * FROM roles_private.is_member_of($1, $2)',
        [objs.VpEng.id, objs.engTeam.id]
      );
      const { is_member_of: isDesigner } = await db.one(
        'SELECT * FROM roles_private.is_member_of($1, $2)',
        [objs.designer.id, objs.designTeam.id]
      );
      expect(isVpEng).toBe(false);
      expect(isDesigner).toBe(false);
    });
    it('cannot create bad organization_id', async () => {
      let failed = false;
      try {
        await conn.one('SELECT * FROM roles_public.register_team($1, $2, $3)', [
          'engineering team',
          objs.webql.id,
          objs.engTeam.id
        ]);
      } catch (e) {
        failed = true;
        expect(e.message).toEqual('ORGANIZATION_MISMASTCH');
      }
      expect(failed).toBe(true);
    });
    it('cannot set organization with parent_id', async () => {
      let failed = false;
      try {
        await db.none(
          'UPDATE roles_public.roles SET parent_id=$1 WHERE id=$2',
          [objs.qaTeam.id, objs.sinai.id]
        );
      } catch (e) {
        failed = true;
        expect(e.message).toEqual('ROLES_ONLY_TEAMS_HAVE_PARENTS');
      }
      expect(failed).toBe(true);
    });
    it('cannot create parent_id with outside organization_id', async () => {
      let failed = false;
      try {
        await db.none(
          'UPDATE roles_public.roles SET parent_id=$1 WHERE id=$2',
          [objs.webql.id, objs.qaTeam.id]
        );
      } catch (e) {
        failed = true;
        expect(e.message).toEqual('ORGANIZATION_MISMASTCH');
      }
      expect(failed).toBe(true);
    });
    it('can create parent_id with organization_id', async () => {
      await db.none('UPDATE roles_public.roles SET parent_id=$1 WHERE id=$2', [
        objs.sinai.id,
        objs.qaTeam.id
      ]);
    });
    it('cannot create bad parent_id', async () => {
      let failed = false;
      try {
        await db.none(
          'UPDATE roles_public.roles SET parent_id=$1 WHERE id=$2',
          [objs.qaTeam.id, objs.engTeam.id]
        );
      } catch (e) {
        failed = true;
        expect(e.message).toEqual('ROLES_TEAM_CIRCULAR_REF');
      }
      expect(failed).toBe(true);
    });
  });
  describe('qaDev', () => {
    it('sees only n roles', async () => {
      conn.setContext({
        role: 'authenticated',
        'jwt.claims.role_id': objs.qaDev.id
      });
      const roles = await conn.many('SELECT * FROM roles_public.roles');
      expect(roles.length).toBe(2);
      expect(roles.find(r => r.type === 'User').id).toEqual(objs.qaDev.id);
      expect(roles.find(r => r.type === 'Team').id).toEqual(objs.qaTeam.id);
    });
  });
  describe('juniorDev', () => {
    beforeEach(() => {
      conn.setContext({
        role: 'authenticated',
        'jwt.claims.role_id': objs.juniorDev.id
      });
      db.setContext({
        role: 'authenticated',
        'jwt.claims.role_id': objs.juniorDev.id
      });
    });
    it('sees only n roles', async () => {
      const roles = await conn.many('SELECT * FROM roles_public.roles');
      expect(roles.length).toBe(2);
      expect(roles.find(r => r.type === 'User').id).toEqual(objs.juniorDev.id);
      expect(roles.find(r => r.type === 'Team').id).toEqual(objs.juniorTeam.id);
    });
    it('has some memberships', async () => {
      const teams = [objs.juniorTeam];
      const noteams = [objs.engTeam, objs.qaTeam, objs.designTeam];
      for (let i = 0; i < teams.length; i++) {
        const { is_member_of: isMember } = await db.one(
          'SELECT * FROM roles_private.is_member_of($1, $2)',
          [objs.juniorDev.id, teams[i].id]
        );
        expect(isMember).toBe(true);
      }
      for (let i = 0; i < noteams.length; i++) {
        const { is_member_of: isMember } = await db.one(
          'SELECT * FROM roles_private.is_member_of($1, $2)',
          [objs.juniorDev.id, noteams[i].id]
        );
        expect(isMember).toBe(false);
      }
    });
    it('has no ownerships', async () => {
      const teams = [
        objs.engTeam,
        objs.juniorTeam,
        objs.qaTeam,
        objs.designTeam
      ];
      for (let i = 0; i < teams.length; i++) {
        const { is_admin_of: isAdmin } = await db.one(
          'SELECT * FROM roles_private.is_admin_of($1, $2)',
          [objs.juniorDev.id, teams[i].id]
        );
        expect(isAdmin).toBe(false);
      }
    });
  });
  describe('VpEng', () => {
    beforeEach(() => {
      conn.setContext({
        role: 'authenticated',
        'jwt.claims.role_id': objs.VpEng.id
      });
      db.setContext({
        role: 'authenticated',
        'jwt.claims.role_id': objs.VpEng.id
      });
    });
    it('sees only n roles', async () => {
      const roles = await conn.many('SELECT * FROM roles_public.roles');
      expect(roles.length).toBe(4);
    });
    it('has some memberships', async () => {
      const teams = [objs.juniorTeam, objs.engTeam, objs.qaTeam];
      const noteams = [objs.designTeam];
      for (let i = 0; i < teams.length; i++) {
        const { is_member_of: isMember } = await db.one(
          'SELECT * FROM roles_private.is_member_of($1, $2)',
          [objs.VpEng.id, teams[i].id]
        );
        expect(isMember).toBe(true);
      }
      for (let i = 0; i < noteams.length; i++) {
        const { is_member_of: isMember } = await db.one(
          'SELECT * FROM roles_private.is_member_of($1, $2)',
          [objs.VpEng.id, noteams[i].id]
        );
        expect(isMember).toBe(false);
      }
    });
    it('has some ownerships', async () => {
      const teams = [objs.juniorTeam, objs.engTeam, objs.qaTeam];
      const noteams = [objs.designTeam];
      for (let i = 0; i < teams.length; i++) {
        const { is_admin_of: isAdmin } = await db.one(
          'SELECT * FROM roles_private.is_admin_of($1, $2)',
          [objs.VpEng.id, teams[i].id]
        );
        expect(isAdmin).toBe(true);
      }
      for (let i = 0; i < noteams.length; i++) {
        const { is_admin_of: isAdmin } = await db.one(
          'SELECT * FROM roles_private.is_admin_of($1, $2)',
          [objs.VpEng.id, noteams[i].id]
        );
        expect(isAdmin).toBe(false);
      }
    });
  });
});