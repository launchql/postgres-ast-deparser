import { closeConnections, createUser, getConnections } from '../../utils';

let db, conn;
let objs = {};
let profiles;

async function expectRepos(conn, user, num) {
  conn.setContext({
    role: 'authenticated',
    'jwt.claims.user_id': user.id
  });
  const projs = await conn.any(`SELECT * FROM projects_public.project`);
  expect(projs.length).toBe(num);
}

async function transferRepo(conn, project_id, new_owner_id) {
  await conn.any(
    `INSERT INTO projects_public.project_transfer (project_id, new_owner_id) VALUES ($1, $2)`,
    [project_id, new_owner_id]
  );
}
async function acceptTransfer(conn, id) {
  await conn.any(
    `UPDATE projects_public.project_transfer SET accepted=TRUE WHERE id=$1`,
    [id]
  );
}
async function abortTransfer(conn, project_id) {
  await conn.any(
    `DELETE FROM projects_public.project_transfer WHERE project_id=$1`,
    [project_id]
  );
}

async function rejectTransfer(conn, id) {
  await conn.any(`DELETE FROM projects_public.project_transfer WHERE id=$1`, [
    id
  ]);
}

describe('transfer repos', () => {
  beforeEach(async () => {
    ({ db, conn } = await getConnections());
    objs.admin = await createUser(db);
    objs.otherAdmin = await createUser(db);
    conn.setContext({
      role: 'authenticated',
      'jwt.claims.user_id': objs.otherAdmin.id
    });
    objs.webql = await conn.one(
      `SELECT * FROM roles_public.register_organization($1)`,
      ['webql']
    );
    conn.setContext({
      role: 'authenticated',
      'jwt.claims.user_id': objs.admin.id
    });
    objs.sinai = await conn.one(
      `SELECT * FROM roles_public.register_organization($1)`,
      ['sinai']
    );

    profiles = await db.many('SELECT * FROM permissions_public.profile');
    profiles = profiles.reduce((m, profile) => {
      m[profile.organization_id] = m[profile.organization_id] || {};
      m[profile.organization_id][profile.name] = profile;
      return m;
    }, {});

    // design team
    objs.designer = await createUser(db);
    objs.designTeam = await conn.one(
      `SELECT * FROM roles_public.register_team($1, $2)`,
      ['design team', objs.sinai.id]
    );
    await conn.any(
      `INSERT INTO roles_public.memberships (role_id, group_id, profile_id, organization_id) VALUES ($1, $2, $3, $4)`,
      [
        objs.designer.id,
        objs.designTeam.id,
        profiles[objs.sinai.id].Owner.id,
        objs.sinai.id
      ]
    );

    // engineering team
    objs.VpEng = await createUser(db);
    objs.developer = await createUser(db);

    objs.engTeam = await conn.one(
      `SELECT * FROM roles_public.register_team($1, $2)`,
      ['engineering team', objs.sinai.id]
    );
    await conn.any(
      `INSERT INTO roles_public.memberships (role_id, group_id, profile_id, organization_id) VALUES ($1, $2, $3, $4)`,
      [
        objs.VpEng.id,
        objs.engTeam.id,
        profiles[objs.sinai.id].Owner.id,
        objs.sinai.id
      ]
    );
    await conn.any(
      `INSERT INTO roles_public.memberships (role_id, group_id, profile_id, organization_id) VALUES ($1, $2, $3, $4)`,
      [
        objs.developer.id,
        objs.engTeam.id,
        profiles[objs.sinai.id].Contributor.id,
        objs.sinai.id
      ]
    );

    // qa devs
    objs.qaDev = await createUser(db);
    objs.qaTeam = await conn.one(
      `SELECT * FROM roles_public.register_team($1, $2, $3)`,
      ['QA', objs.sinai.id, objs.engTeam.id]
    );
    await conn.any(
      `INSERT INTO roles_public.memberships (role_id, group_id, profile_id, organization_id) VALUES ($1, $2, $3, $4)`,
      [
        objs.qaDev.id,
        objs.qaTeam.id,
        profiles[objs.sinai.id].Contributor.id,
        objs.sinai.id
      ]
    );

    // junior devs
    objs.juniorDev = await createUser(db);
    objs.juniorTeam = await conn.one(
      `SELECT * FROM roles_public.register_team($1, $2, $3)`,
      ['junior devs', objs.sinai.id, objs.engTeam.id]
    );
    await conn.any(
      `INSERT INTO roles_public.memberships (role_id, group_id, profile_id, organization_id) VALUES ($1, $2, $3, $4)`,
      [
        objs.juniorDev.id,
        objs.juniorTeam.id,
        profiles[objs.sinai.id].Contributor.id,
        objs.sinai.id
      ]
    );
  });
  afterEach(async () => {
    await closeConnections({ db, conn });
  });
  describe('VP Eng Creates a proj for his team(s)', () => {
    let proj;
    beforeEach(async () => {
      conn.setContext({
        role: 'authenticated',
        'jwt.claims.user_id': objs.VpEng.id
      });

      await conn.none(
        'INSERT INTO projects_public.project (name, owner_id) VALUES ($1, $2)',
        ['newProject', objs.VpEng.id]
      );

      // NOTE 
      // we have an issue! 
      // we need to change triggers to BEFORE INSERT!

      proj = await conn.one(
        'SELECT * FROM projects_public.project where owner_id=$1',
        [objs.VpEng.id]
      );

      await expectRepos(conn, objs.VpEng, 1);
    });
    describe('transfers between people', () => {
      let transfer;
      beforeEach(async () => {
        await transferRepo(conn, proj.id, objs.juniorDev.id);
        transfer = await conn.one(
          `SELECT id FROM projects_public.project_transfer WHERE project_id=$1`,
          [proj.id]
        );
      });
      it('jobs', async () => {
        const projsAfter = await conn.any(
          `SELECT * FROM projects_public.project`
        );

        const jobs = await db.any(
          `SELECT * FROM app_jobs.jobs WHERE task_identifier=$1`,
          ['project__transfer_project_email']
        );

        expect(jobs.length).toBe(1);
        const { transfer_token, ...rest } = jobs[0].payload;
        expect(rest).toEqual({
          project_id: proj.id,
          current_owner_id: objs.VpEng.id,
          new_owner_id: objs.juniorDev.id,
          sender_id: objs.VpEng.id
        });
        expect(transfer_token).toBeTruthy();
        expect(projsAfter.length).toBe(1);
      });
      it('only owners can accept', async () => {
        await acceptTransfer(conn, transfer.id);
        const transferAfter = await conn.one(
          `SELECT id, accepted FROM projects_public.project_transfer WHERE project_id=$1`,
          [proj.id]
        );
        expect(transferAfter.accepted).toBe(false);
      });
      it('owners can accept', async () => {
        conn.setContext({
          role: 'authenticated',
          'jwt.claims.user_id': objs.juniorDev.id
        });
        await acceptTransfer(conn, transfer.id);
        const transferAfter = await conn.one(
          `SELECT id, accepted FROM projects_public.project_transfer WHERE project_id=$1`,
          [proj.id]
        );
        expect(transferAfter.accepted).toBe(true);
        await expectRepos(conn, objs.VpEng, 0);
        await expectRepos(conn, objs.juniorDev, 1);
      });
      it('abort', async () => {
        await abortTransfer(conn, proj.id);
        await expectRepos(conn, objs.VpEng, 1);
        await expectRepos(conn, objs.juniorDev, 0);
      });
      it('reject', async () => {
        conn.setContext({
          role: 'authenticated',
          'jwt.claims.user_id': objs.juniorDev.id
        });
        await rejectTransfer(conn, transfer.id);

        await expectRepos(conn, objs.VpEng, 1);
        await expectRepos(conn, objs.juniorDev, 0);
      });
      it('EXCLUDE CONSTRAINT', async () => {
        let failed = false;
        try {
          await transferRepo(conn, proj.id, objs.juniorDev.id);
        } catch (e) {
          failed = true;
          expect(e.message).toEqual(
            'conflicting key value violates exclusion constraint "uniq_transfer_using_expires"'
          );
        }
        expect(failed);
      });
    });
    describe('transfers to organization', () => {
      let transfer;
      beforeEach(async () => {
        await transferRepo(conn, proj.id, objs.webql.id);
        transfer = await conn.one(
          `SELECT id FROM projects_public.project_transfer WHERE project_id=$1`,
          [proj.id]
        );
      });
      it('owners can accept', async () => {
        conn.setContext({
          role: 'authenticated',
          'jwt.claims.user_id': objs.otherAdmin.id
        });
        await acceptTransfer(conn, transfer.id);

        await expectRepos(conn, objs.VpEng, 0);
        await expectRepos(conn, objs.otherAdmin, 1);
      });
      it('abort', async () => {
        await abortTransfer(conn, proj.id);

        await expectRepos(conn, objs.VpEng, 1);
        await expectRepos(conn, objs.otherAdmin, 0);
      });
      it('reject', async () => {
        conn.setContext({
          role: 'authenticated',
          'jwt.claims.user_id': objs.otherAdmin.id
        });
        await rejectTransfer(conn, transfer.id);

        await expectRepos(conn, objs.VpEng, 1);
        await expectRepos(conn, objs.otherAdmin, 0);
      });
    });
    describe('transfers from organization', () => {
      let transfer, proj;
      beforeEach(async () => {
        conn.setContext({
          role: 'authenticated',
          'jwt.claims.user_id': objs.otherAdmin.id
        });
        proj = await conn.one(
          `INSERT INTO projects_public.project (name, owner_id) VALUES ($1, $2) RETURNING *`,
          ['newApp', objs.webql.id]
        );

        await expectRepos(conn, objs.otherAdmin, 1);
        await transferRepo(conn, proj.id, objs.sinai.id);
        transfer = await conn.one(
          `SELECT id FROM projects_public.project_transfer WHERE project_id=$1`,
          [proj.id]
        );
      });
      it('owners can accept', async () => {
        conn.setContext({
          role: 'authenticated',
          'jwt.claims.user_id': objs.admin.id
        });

        await acceptTransfer(conn, transfer.id);

        await expectRepos(conn, objs.admin, 1);
        await expectRepos(conn, objs.otherAdmin, 0);
      });
      it('abort', async () => {
        await abortTransfer(conn, proj.id);
        await expectRepos(conn, objs.otherAdmin, 1);
        await expectRepos(conn, objs.admin, 0);
      });
      it('reject', async () => {
        conn.setContext({
          role: 'authenticated',
          'jwt.claims.user_id': objs.admin.id
        });
        await rejectTransfer(conn, transfer.id);
        await expectRepos(conn, objs.otherAdmin, 1);
        await expectRepos(conn, objs.admin, 0);
      });
    });
  });
});