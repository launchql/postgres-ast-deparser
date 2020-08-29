import { closeConnections, createUser, getConnections } from '../../utils';

let db, conn;
let objs = {};

async function createOrganization(name) {
  return await conn.one('SELECT * FROM roles_public.register_organization($1)', [
    name
  ]);
}

async function createTeam(name, organization_id, parent_id) {
  return await conn.one('SELECT * FROM roles_public.register_team($1, $2, $3)', [
    name,
    organization_id,
    parent_id
  ]);
}

async function addMember(role_id, group_id, profile_id, organization_id) {
  await conn.any(
    'INSERT INTO roles_public.memberships (role_id, group_id, profile_id, organization_id) VALUES ($1, $2, $3, $4)',
    [role_id, group_id, profile_id, organization_id]
  );
}

async function permitted_on_role(opts) {
  const { permitted_on_role: res } =  await db.one('SELECT permissions_private.permitted_on_role($1, $2, $3, $4)', [
    opts.action_type,
    opts.object_type,
    opts.role_id,
    opts.actor_id
  ]);
  return res;
}

describe('collaboration', () => {
  beforeEach(async () => {
    ({ db, conn } = await getConnections());
    objs.user1 = await createUser(db, undefined, 'user1');
    objs.user2 = await createUser(db, undefined, 'user2');
    objs.user3 = await createUser(db, undefined, 'user3');
    objs.user4 = await createUser(db, undefined, 'user4');
    objs.user5 = await createUser(db, undefined, 'user5');

    conn.setContext({
      role: 'authenticated',
      'jwt.claims.role_id': objs.user1.id
    });

    objs.org1 = await createOrganization('org1');

    objs.profiles = await db.many('SELECT * FROM permissions_public.profile');
    objs.profiles = objs.profiles.reduce((m, profile) => {
      m[profile.organization_id] = m[profile.organization_id] || {};
      m[profile.organization_id][profile.name] = profile;
      return m;
    }, {});

    objs.team1 = await createTeam('team1', objs.org1.id);
    objs.team2 = await createTeam('team2', objs.org1.id, objs.team1.id);

    await addMember(
      objs.user2.id,
      objs.team1.id,
      objs.profiles[objs.org1.id].Contributor.id,
      objs.org1.id
    );

    await addMember(
      objs.user3.id,
      objs.team2.id,
      objs.profiles[objs.org1.id].Contributor.id,
      objs.org1.id
    );

    objs.teams = {
      [objs.team1.id]: objs.team1,
      [objs.team2.id]: objs.team2
    };

  });
  afterEach(async () => {
    await closeConnections({ db, conn });
  });
  it('add collaborations', async () => {
    const allGrants = await db.any(
      'SELECT * FROM permissions_private.team_permits ORDER BY NAME'
    );

    const testGrants = allGrants
      .map(({ role_id, group, username, name }) => ({
        role_id,
        username,
        group,
        name
      }))
      .reduce((m, v) => {
        m[v.username] = m[v.username] || {};
        m[v.username][v.group] =
          m[v.username][v.group] || [];
        m[v.username][v.group].push(v.name);
        return m;
      }, {});

    expect(testGrants).toMatchSnapshot();

    const makeCase = (name) => {
      const [
        _can,
        username,
        action_type,
        object_type,
        _on,
        groupName
      ] = name.split(' ');
      return {
        name,
        action_type,
        object_type,
        role_id: objs[groupName] && objs[groupName].id,
        actor_id: objs[username] && objs[username].id
      };
    };

    const cases = [
      makeCase('can user1 add user on team1'),
      makeCase('can user2 add user on team1'),
      makeCase('can user3 add user on team1'),
      makeCase('can user4 add user on team1'),
      
      makeCase('can user1 add user on team2'),
      makeCase('can user2 add user on team2'),
      makeCase('can user3 add user on team2'),
      makeCase('can user4 add user on team2'),

      makeCase('can user1 approve invite on team2'),
      makeCase('can user2 approve invite on team2'),
      makeCase('can user3 approve invite on team2'),
      makeCase('can user4 approve invite on team2'),
    ];
    const results = {};
    for (let cs of cases) {
      await (async (cs) => {
        results[cs.name] = await permitted_on_role(cs);
      })(cs);
    }

    expect(results).toMatchSnapshot();
  });
});
