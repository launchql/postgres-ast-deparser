import { closeConnections, createUser, getConnections } from '../../utils';

let db, conn;
const objs = {};

async function createOrganization(name) {
  return await conn.one(
    'SELECT * FROM roles_public.register_organization($1)',
    [name]
  );
}

async function createTeam(name, organization_id, parent_id) {
  return await conn.one(
    'SELECT * FROM roles_public.register_team($1, $2, $3)',
    [name, organization_id, parent_id]
  );
}

async function addMember(role_id, group_id, profile_id, organization_id) {
  await conn.any(
    'INSERT INTO roles_public.memberships (role_id, group_id, profile_id, organization_id) VALUES ($1, $2, $3, $4)',
    [role_id, group_id, profile_id, organization_id]
  );
}
const makeCase = (name) => {
  const parts = name.split(' ');
  if (parts.length === 6) {
    const [username, _is, _a, profilename, _on, teamname] = parts;
    return {
      name,
      toBe: true,
      args: [
        objs[username].id,
        objs[teamname].id,
        objs.profiles[objs.org1.id][profilename].id
      ]
    };
  } else {
    const [username, _is, _not, _a, profilename, _on, teamname] = parts;
    return {
      name,
      toBe: false,
      args: [
        objs[username].id,
        objs[teamname].id,
        objs.profiles[objs.org1.id][profilename].id
      ]
    };
  }
};

async function expectCases(cases) {
  const madeCases = cases.map((c) => makeCase(c));

  const results = {};
  for (const cs of madeCases) {
    await (async (cs) => {
      const res = await db.one(
        `
      SELECT EXISTS (SELECT 1 FROM roles_public.memberships
        WHERE role_id=$1 
        AND group_id=$2
        AND profile_id=$3)
      `,
        cs.args
      );
      results[cs.name] = res.exists === cs.toBe;
    })(cs);
  }
  return results;
}
describe('cascading memberships', () => {
  beforeAll(async () => {
    ({ db, conn } = await getConnections());
    objs.user1 = await createUser(db);
    objs.user2 = await createUser(db);
    objs.user3 = await createUser(db);

    conn.setContext({
      role: 'authenticated',
      'jwt.claims.user_id': objs.user1.id
    });

    objs.org1 = await createOrganization('org1');

    objs.profiles = await db.many('SELECT * FROM permissions_public.profile');
    objs.profiles = objs.profiles.reduce((m, profile) => {
      m[profile.organization_id] = m[profile.organization_id] || {};
      m[profile.organization_id][profile.name] = profile;
      return m;
    }, {});

    objs.teamA = await createTeam('teamA', objs.org1.id);
    objs.teamB = await createTeam('teamB', objs.org1.id, objs.teamA.id);
    objs.teamC = await createTeam('teamC', objs.org1.id, objs.teamA.id);
    objs.teamD = await createTeam('teamD', objs.org1.id, objs.teamC.id);
    objs.teamE = await createTeam('teamE', objs.org1.id, objs.teamC.id);
    objs.teamF = await createTeam('teamF', objs.org1.id, objs.teamD.id);

    await addMember(
      objs.user2.id,
      objs.org1.id,
      objs.profiles[objs.org1.id].Member.id,
      objs.org1.id
    );
    await addMember(
      objs.user2.id,
      objs.teamA.id,
      objs.profiles[objs.org1.id].Contributor.id,
      objs.org1.id
    );

    await addMember(
      objs.user3.id,
      objs.org1.id,
      objs.profiles[objs.org1.id].Editor.id,
      objs.org1.id
    );
    await addMember(objs.user3.id, objs.teamC.id, null, objs.org1.id);

    //  (org1)   -- user2 M   --- user3 Editor
    //    |
    //   (A)     -- user2 C
    //   / \
    // (B) (C)    ---- user3 (null)
    //     / \
    //   (D) (E)
    //   /
    // (F)
  });
  afterAll(async () => {
    await closeConnections({ db, conn });
  });
  it('default profiles from organization', async () => {
    expect(
      await expectCases([
        'user1 is a Owner on teamA',
        'user1 is a Owner on teamB',
        'user1 is a Owner on teamC',
        'user1 is a Owner on teamD'
      ])
    ).toMatchSnapshot();
  });
  it('inherits org profile', async () => {
    expect(
      await expectCases([
        'user3 is not a Editor on teamA',
        'user3 is not a Editor on teamB',
        'user3 is a Editor on teamC',
        'user3 is a Editor on teamD',
        'user3 is a Editor on teamE',
        'user3 is a Editor on teamF'
      ])
    ).toMatchSnapshot();
  });
  it('user2 has a', async () => {
    expect(
      await expectCases([
        'user3 is a Editor on teamD',
        'user3 is a Editor on teamF'
      ])
    ).toMatchSnapshot();
  });
});
