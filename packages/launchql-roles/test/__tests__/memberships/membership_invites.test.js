import { closeConnections, createUser, getConnections } from '../../utils';

let db,
  conn,
  admin,
  user1,
  user2,
  user3,
  organization,
  anotherOrg,
  anotherAdmin,
  profiles;

const expectInvites = async (conn, user, numInvites) => {
  conn.setContext({
    role: 'authenticated',
    'jwt.claims.user_id': user.id
  });
  const invites = await conn.any(
    'SELECT id, approved, accepted FROM roles_public.membership_invites'
  );
  expect(invites.length).toBe(numInvites);

  for (let i = 0; i < invites.length; i++) {
    await conn.any('DELETE FROM roles_public.membership_invites WHERE id=$1', [
      invites[i].id
    ]);
  }

  const invitesAfter = await conn.any(
    'SELECT id, approved, accepted FROM roles_public.membership_invites'
  );
  expect(invitesAfter.length).toBe(0);
};

const inviteMember = async (
  conn,
  email,
  role_id,
  group_id,
  organization_id
) => {
  const profile_id = profiles[organization_id].Contributor.id;
  await conn.any(
    `
    INSERT INTO roles_public.membership_invites
      ( role_id, email, group_id, profile_id, organization_id )
      VALUES
      ($1, $2, $3, $4, $5);
    `,
    [role_id, email, group_id, profile_id, organization_id]
  );
};

const grantAdmin = async (conn, admin, organization) => {
  const profile_id = profiles[organization.id].Owner.id;
  await conn.any(
    `
    INSERT INTO roles_public.memberships
      ( role_id, group_id, profile_id, organization_id)
      VALUES
      ($1, $2, $3, $4);
    `,
    [admin.id, organization.id, profile_id, organization.id]
  );
};

describe('membership invites', () => {
  beforeEach(async () => {
    ({ db, conn } = await getConnections());
    admin = await createUser(db);
    user1 = await createUser(db);
    user2 = await createUser(db);
    user3 = await createUser(db);
    anotherAdmin = await createUser(db);
    conn.setContext({
      role: 'authenticated',
      'jwt.claims.user_id': admin.id
    });
    organization = await conn.one(
      'SELECT * FROM roles_public.register_organization($1)',
      ['my amazing organization']
    );
    anotherOrg = await conn.one(
      'SELECT * FROM roles_public.register_organization($1)',
      ['another amazing organization']
    );
    profiles = await db.many('SELECT * FROM permissions_public.profile');
    profiles = profiles.reduce((m, profile) => {
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
    expect(organization.username).toEqual('my_amazing_organization');
    expect(roles.length).toBe(3);
  });
  it('admin can invite an existing user by role_id', async () => {
    const results = await db.any(
      'SELECT * FROM roles_private.is_admin_of($1, $2)',
      [admin.id, organization.id]
    );

    await inviteMember(conn, null, user1.id, organization.id, organization.id);
    // const invite = await conn.one(
    //   'SELECT id, approved FROM roles_public.membership_invites WHERE role_id=$1',
    //   [user1.id]
    // );
    // expect(invite).toBeTruthy();
    // expect(invite.approved).toEqual(true);
  });
  it('admin can invite an existing user by email', async () => {
    await inviteMember(
      conn,
      user1.email,
      null,
      organization.id,
      organization.id
    );
    const invite = await conn.one(
      'SELECT id, role_id, approved, accepted FROM roles_public.membership_invites WHERE role_id=$1',
      [user1.id]
    );
    expect(invite).toBeTruthy();
    expect(invite.role_id).toEqual(user1.id);
    expect(invite.approved).toEqual(true);
    expect(invite.email).toBeFalsy();
  });
  describe('user1 is a member', () => {
    beforeEach(async () => {
      await conn.any(
        'INSERT INTO roles_public.memberships (role_id, group_id, profile_id, organization_id) VALUES ($1, $2, $3, $4)',
        [
          user1.id,
          organization.id,
          profiles[organization.id].Contributor.id,
          organization.id
        ]
      );
      conn.setContext({
        role: 'authenticated',
        'jwt.claims.user_id': user1.id
      });

      await grantAdmin(db, anotherAdmin, organization);

      await inviteMember(
        conn,
        null,
        user2.id,
        organization.id,
        organization.id
      );
    });
    describe('access', () => {
      beforeEach(async () => {
        conn.setContext({
          role: 'authenticated',
          'jwt.claims.user_id': admin.id
        });
        await inviteMember(
          conn,
          null,
          user1.id,
          organization.id,
          organization.id
        );
        await inviteMember(conn, null, user1.id, anotherOrg.id, anotherOrg.id);
        await inviteMember(conn, null, user2.id, anotherOrg.id, anotherOrg.id);
      });
      it('admin', async () => {
        await expectInvites(conn, admin, 4);
      });
      it('user1', async () => {
        await expectInvites(conn, user1, 3);
      });
      it('user2', async () => {
        await expectInvites(conn, user2, 2);
      });
      it('user3', async () => {
        await expectInvites(conn, user3, 0);
      });
    });
    it('job created', async () => {
      const jobs = await db.any(
        'SELECT * FROM app_jobs.jobs WHERE task_identifier=$1 OR task_identifier=$2',
        [
          'membership__invite_member_approval_email',
          'membership__invite_member_email'
        ]
      );
      expect(jobs.length).toBe(1);

      const [{ payload }] = jobs;
      expect(payload).toEqual(
        expect.objectContaining({
          type: 'Organization'
        })
      );
      expect(payload.admin_emails).toBeTruthy();
      expect(payload.invitee_email).toBeTruthy();
      expect(payload.invite_token).toBeTruthy();
    });
    it('can invite a user, but requires approval', async () => {
      conn.setContext({
        role: 'authenticated',
        'jwt.claims.user_id': admin.id
      });

      const invite = await conn.one(
        'SELECT id, approved, accepted FROM roles_public.membership_invites WHERE role_id=$1 AND group_id=$2',
        [user2.id, organization.id]
      );
      expect(invite).toBeTruthy();
      expect(invite.approved).toEqual(false);

      conn.setContext({
        role: 'authenticated',
        'jwt.claims.user_id': user2.id
      });
      let failed = false;
      try {
        const updated = await conn.any(
          'UPDATE roles_public.membership_invites SET approved=TRUE WHERE id=$1 RETURNING id',
          [invite.id]
        );
        expect(updated.length).toBe(0);
      } catch (e) {
        failed = true;
        expect(e.message).toEqual('INVITES_ONLY_ADMIN_APPROVE');
      }

      expect(failed).toBe(true);
      const inviteAfter = await conn.one(
        'SELECT id, approved, accepted FROM roles_public.membership_invites WHERE role_id=$1 AND group_id=$2',
        [user2.id, organization.id]
      );

      expect(inviteAfter).toBeTruthy();
      expect(inviteAfter.approved).toEqual(false);
    });
    it('admin can approve', async () => {
      // now approval
      conn.setContext({
        role: 'authenticated',
        'jwt.claims.user_id': admin.id
      });

      const invite = await conn.one(
        'SELECT id, approved, accepted FROM roles_public.membership_invites WHERE role_id=$1',
        [user2.id]
      );
      expect(invite).toBeTruthy();
      expect(invite.approved).toEqual(false);

      const updated = await conn.any(
        'UPDATE roles_public.membership_invites SET approved=TRUE WHERE id=$1 RETURNING id',
        [invite.id]
      );

      const inviteAfter = await conn.one(
        'SELECT id, approved, accepted FROM roles_public.membership_invites WHERE role_id=$1 AND group_id=$2',
        [user2.id, organization.id]
      );

      expect(updated.length).toBe(1);
      expect(inviteAfter).toBeTruthy();
      expect(inviteAfter.approved).toEqual(true);

      const jobs = await db.any(
        'SELECT * FROM app_jobs.jobs WHERE task_identifier=$1 OR task_identifier=$2',
        [
          'membership__invite_member_approval_email',
          'membership__invite_member_email'
        ]
      );

      expect(jobs.length).toBe(2);

      const [{ payload }] = jobs;
      expect(payload).toEqual(
        expect.objectContaining({
          type: 'Organization'
        })
      );
      expect(payload.admin_emails).toBeTruthy();
      expect(payload.invitee_email).toBeTruthy();
      expect(payload.invite_token).toBeTruthy();
    });
  });
});
