import { closeConnections, createUser, getConnections } from '../../utils';

let db, conn;
let objs = {};

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

async function addProject(name, owner_id) {
  return await conn.one(
    `INSERT INTO projects_public.project
    (name, owner_id)
    VALUES ($1, $2) RETURNING *`,
    [name, owner_id]
  );
}

async function addCollaboration(
  role_id,
  profile_id,
  project_id,
  organization_id
) {
  await conn.any(
    `INSERT INTO collaboration_public.collaboration
    (role_id, profile_id, project_id, organization_id)
    VALUES ($1, $2, $3, $4)`,
    [role_id, profile_id, project_id, organization_id]
  );
}

async function can(opts) {
  const { permitted_on_project: res } = await db.one(
    'SELECT collaboration_private.permitted_on_project($1, $2, $3, $4)',
    [opts.action_type, opts.object_type, opts.project_id, opts.actor_id]
  );
  return res;
}

const makeCase = name => {
  const [
    _can,
    username,
    action_type,
    object_type,
    _on,
    project_name
  ] = name.split(' ');
  return {
    name,
    action_type,
    object_type,
    project_id: objs[project_name] && objs[project_name].id,
    actor_id: objs[username] && objs[username].id
  };
};

async function expectCases(cases) {
  const madeCases = cases.map(c => makeCase(c));

  const results = {};
  for (let cs of madeCases) {
    await (async cs => {
      results[cs.name] = await can(cs);
    })(cs);
  }
  return results;
}

describe('collaboration', () => {
  beforeEach(async () => {
    ({ db, conn } = await getConnections());
    objs.user1 = await createUser(db, undefined, 'user1');
    objs.user2 = await createUser(db, undefined, 'user2');
    objs.user3 = await createUser(db, undefined, 'user3');
    objs.user4 = await createUser(db, undefined, 'user4');
    objs.user5 = await createUser(db, undefined, 'user5');
    objs.user6 = await createUser(db, undefined, 'user6');
    objs.user7 = await createUser(db, undefined, 'user7');
    objs.user8 = await createUser(db, undefined, 'user8');
    objs.user9 = await createUser(db, undefined, 'user9');

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

    //          (org1)  - - - (user1 Owner) (user9 Contributor)
    //            |
    //           (A)- - - - (user2 Contributor)
    //           / \
    //         (B) (C) - - - - (user3 Administrator)
    //             / \         (user5 Contributor)
    // user7 - - (D)  (E)  - - user6   (both Contributor)
    //           /  \
    // user8 - (F)   p3
    //            \
    //             p1 - - - (user4 Contributor)
    //
    // p2 (no team or anything)

    objs.teamA = await createTeam('teamA', objs.org1.id);
    objs.teamB = await createTeam('teamB', objs.org1.id, objs.teamA.id);
    objs.teamC = await createTeam('teamC', objs.org1.id, objs.teamA.id);
    objs.teamD = await createTeam('teamD', objs.org1.id, objs.teamC.id);
    objs.teamE = await createTeam('teamE', objs.org1.id, objs.teamC.id);
    objs.teamF = await createTeam('teamF', objs.org1.id, objs.teamD.id);

    // MEMBERSHIPS

    await addMember(
      objs.user2.id,
      objs.teamA.id,
      objs.profiles[objs.org1.id].Contributor.id,
      objs.org1.id
    );

    await addMember(
      objs.user3.id,
      objs.teamC.id,
      objs.profiles[objs.org1.id].Administrator.id,
      objs.org1.id
    );

    await addMember(
      objs.user5.id,
      objs.teamC.id,
      objs.profiles[objs.org1.id].Contributor.id,
      objs.org1.id
    );
    await addMember(
      objs.user6.id,
      objs.teamE.id,
      objs.profiles[objs.org1.id].Contributor.id,
      objs.org1.id
    );
    await addMember(
      objs.user7.id,
      objs.teamD.id,
      objs.profiles[objs.org1.id].Contributor.id,
      objs.org1.id
    );
    await addMember(
      objs.user8.id,
      objs.teamF.id,
      objs.profiles[objs.org1.id].Contributor.id,
      objs.org1.id
    );
    await addMember(
      objs.user9.id,
      objs.org1.id,
      objs.profiles[objs.org1.id].Contributor.id,
      objs.org1.id
    );

    objs.project1 = await addProject('project1', objs.org1.id);
    objs.project2 = await addProject('project2', objs.org1.id);
    objs.project3 = await addProject('project3', objs.org1.id);

    objs.projects = {
      [objs.project1.id]: objs.project1,
      [objs.project2.id]: objs.project2,
      [objs.project3.id]: objs.project3
    };

    // GRANTS

    await addCollaboration(
      objs.teamF.id,
      objs.profiles[objs.org1.id].Contributor.id,
      objs.project1.id,
      objs.project1.owner_id
    );

    await addCollaboration(
      objs.teamD.id,
      objs.profiles[objs.org1.id].Contributor.id,
      objs.project3.id,
      objs.project3.owner_id
    );

    await addCollaboration(
      objs.user4.id,
      objs.profiles[objs.org1.id].Contributor.id,
      objs.project1.id,
      objs.project1.owner_id
    );
  });
  afterEach(async () => {
    await closeConnections({ db, conn });
  });
  it('testing basic permissions', async () => {
    const results = await expectCases([
      'can user1 read content on project1',
      'can user1 read content on project2',
      'can user1 read content on project3',
      'can user1 read content on whattf',

      'can user2 read content on project1',
      'can user2 read content on project2',
      'can user2 read content on project3',

      'can user3 read content on project1',
      'can user3 read content on project2',
      'can user3 read content on project3',

      'can user4 read content on project1',
      'can user4 read content on project2',
      'can user4 read content on project3',

      'can user5 read content on project1',
      'can user5 read content on project2',
      'can user5 read content on project3',

      'can user6 read content on project1',
      'can user6 read content on project2',
      'can user6 read content on project3',

      'can user7 read content on project1',
      'can user7 read content on project2',
      'can user7 read content on project3',

      'can user8 read content on project1',
      'can user8 read content on project2',
      'can user8 read content on project3',

      'can user9 read content on project1',
      'can user9 read content on project2',
      'can user9 read content on project3',

      'can whoever read content on project2'
    ]);

    expect(results).toEqual({
      'can user1 read content on project1': true,
      'can user1 read content on project2': true,
      'can user1 read content on project3': true,
      'can user1 read content on whattf': null,

      'can user2 read content on project1': true,
      'can user2 read content on project2': false,
      'can user2 read content on project3': true,

      'can user3 read content on project1': true,
      'can user3 read content on project2': false,
      'can user3 read content on project3': true,

      'can user4 read content on project1': true,
      'can user4 read content on project2': false,
      'can user4 read content on project3': false,

      'can user5 read content on project1': true,
      'can user5 read content on project2': false,
      'can user5 read content on project3': true,

      'can user6 read content on project1': false,
      'can user6 read content on project2': false,
      'can user6 read content on project3': false,

      'can user7 read content on project1': true,
      'can user7 read content on project2': false,
      'can user7 read content on project3': true,

      'can user8 read content on project1': true,
      'can user8 read content on project2': false,
      'can user8 read content on project3': false,

      'can user9 read content on project1': false,
      'can user9 read content on project2': false,
      'can user9 read content on project3': false,

      'can whoever read content on project2': null
    });
    expect(results).toMatchSnapshot();
  });
  it('remove a user2', async () => {
    await conn.any(
      `DELETE FROM roles_public.memberships
      WHERE role_id=$1 AND group_id=$2`,
      [objs.user2.id, objs.teamA.id]
    );

    const results = await expectCases([
      'can user2 read content on project1',
      'can user2 read content on project2',
      'can user2 read content on project3'
    ]);

    expect(results).toEqual({
      'can user2 read content on project1': false,
      'can user2 read content on project2': false,
      'can user2 read content on project3': false
    });
    expect(results).toMatchSnapshot();
  });
  it('remove teamF collaboration to project1', async () => {
    await conn.any(
      `DELETE FROM collaboration_public.collaboration
      WHERE role_id=$1 AND project_id=$2`,
      [objs.teamF.id, objs.project1.id]
    );

    const results = await expectCases([
      'can user1 read content on project1',
      'can user2 read content on project1',
      'can user3 read content on project1',
      'can user4 read content on project1',
      'can user5 read content on project1',
      'can user6 read content on project1',
      'can user7 read content on project1',
      'can user8 read content on project1',
      'can user9 read content on project1',
    ]);

    expect(results).toEqual({
      'can user1 read content on project1': true,
      'can user2 read content on project1': false,
      'can user3 read content on project1': false,
      'can user4 read content on project1': true,
      'can user5 read content on project1': false,
      'can user6 read content on project1': false,
      'can user7 read content on project1': false,
      'can user8 read content on project1': false,
      'can user9 read content on project1': false,
    });
    expect(results).toMatchSnapshot(); 
  });
  it('remove user5 from teamC', async () => {
    await conn.any(
      `DELETE FROM roles_public.memberships
      WHERE role_id=$1 AND group_id=$2`,
      [objs.user5.id, objs.teamC.id]
    );
    const results = await expectCases([
      'can user1 read content on project1',
      'can user1 read content on project2',
      'can user1 read content on project3',
      'can user1 read content on whattf',

      'can user2 read content on project1',
      'can user2 read content on project2',
      'can user2 read content on project3',

      'can user3 read content on project1',
      'can user3 read content on project2',
      'can user3 read content on project3',

      'can user4 read content on project1',
      'can user4 read content on project2',
      'can user4 read content on project3',

      'can user5 read content on project1',
      'can user5 read content on project2',
      'can user5 read content on project3',

      'can user6 read content on project1',
      'can user6 read content on project2',
      'can user6 read content on project3',

      'can user7 read content on project1',
      'can user7 read content on project2',
      'can user7 read content on project3',

      'can user8 read content on project1',
      'can user8 read content on project2',
      'can user8 read content on project3',

      'can user9 read content on project1',
      'can user9 read content on project2',
      'can user9 read content on project3',

      'can whoever read content on project2'
    ]);

    expect(results).toEqual({
      'can user1 read content on project1': true,
      'can user1 read content on project2': true,
      'can user1 read content on project3': true,
      'can user1 read content on whattf': null,

      'can user2 read content on project1': true,
      'can user2 read content on project2': false,
      'can user2 read content on project3': true,

      'can user3 read content on project1': true,
      'can user3 read content on project2': false,
      'can user3 read content on project3': true,

      'can user4 read content on project1': true,
      'can user4 read content on project2': false,
      'can user4 read content on project3': false,

      'can user5 read content on project1': false,
      'can user5 read content on project2': false,
      'can user5 read content on project3': false,

      'can user6 read content on project1': false,
      'can user6 read content on project2': false,
      'can user6 read content on project3': false,

      'can user7 read content on project1': true,
      'can user7 read content on project2': false,
      'can user7 read content on project3': true,

      'can user8 read content on project1': true,
      'can user8 read content on project2': false,
      'can user8 read content on project3': false,

      'can user9 read content on project1': false,
      'can user9 read content on project2': false,
      'can user9 read content on project3': false,

      'can whoever read content on project2': null
    });
    expect(results).toMatchSnapshot();
  });
  it('move teamD under teamB', async () => {
    await conn.any(
      `UPDATE roles_public.roles
        SET parent_id=$2
        WHERE id=$1`,
      [objs.teamD.id, objs.teamB.id]
    );
    
    const results = await expectCases([
      'can user1 read content on project1',
      'can user1 read content on project2',
      'can user1 read content on project3',
      'can user1 read content on whattf',

      'can user2 read content on project1',
      'can user2 read content on project2',
      'can user2 read content on project3',

      'can user3 read content on project1',
      'can user3 read content on project2',
      'can user3 read content on project3',

      'can user4 read content on project1',
      'can user4 read content on project2',
      'can user4 read content on project3',

      'can user5 read content on project1',
      'can user5 read content on project2',
      'can user5 read content on project3',

      'can user6 read content on project1',
      'can user6 read content on project2',
      'can user6 read content on project3',

      'can user7 read content on project1',
      'can user7 read content on project2',
      'can user7 read content on project3',

      'can user8 read content on project1',
      'can user8 read content on project2',
      'can user8 read content on project3',

      'can user9 read content on project1',
      'can user9 read content on project2',
      'can user9 read content on project3',

      'can whoever read content on project2'
    ]);

    expect(results).toEqual({
      'can user1 read content on project1': true,
      'can user1 read content on project2': true,
      'can user1 read content on project3': true,
      'can user1 read content on whattf': null,

      'can user2 read content on project1': true,
      'can user2 read content on project2': false,
      'can user2 read content on project3': true,

      'can user3 read content on project1': false,
      'can user3 read content on project2': false,
      'can user3 read content on project3': false,

      'can user4 read content on project1': true,
      'can user4 read content on project2': false,
      'can user4 read content on project3': false,

      'can user5 read content on project1': false,
      'can user5 read content on project2': false,
      'can user5 read content on project3': false,

      'can user6 read content on project1': false,
      'can user6 read content on project2': false,
      'can user6 read content on project3': false,

      'can user7 read content on project1': true,
      'can user7 read content on project2': false,
      'can user7 read content on project3': true,

      'can user8 read content on project1': true,
      'can user8 read content on project2': false,
      'can user8 read content on project3': false,

      'can user9 read content on project1': false,
      'can user9 read content on project2': false,
      'can user9 read content on project3': false,

      'can whoever read content on project2': null
    });
    expect(results).toMatchSnapshot();
    

  });
  it('move teamF under teamE', async () => {
    await conn.any(
      `UPDATE roles_public.roles
        SET parent_id=$2
        WHERE id=$1`,
      [objs.teamF.id, objs.teamE.id]
    );
    
    const results = await expectCases([
      'can user1 read content on project1',
      'can user1 read content on project2',
      'can user1 read content on project3',
      'can user1 read content on whattf',

      'can user2 read content on project1',
      'can user2 read content on project2',
      'can user2 read content on project3',

      'can user3 read content on project1',
      'can user3 read content on project2',
      'can user3 read content on project3',

      'can user4 read content on project1',
      'can user4 read content on project2',
      'can user4 read content on project3',

      'can user5 read content on project1',
      'can user5 read content on project2',
      'can user5 read content on project3',

      'can user6 read content on project1',
      'can user6 read content on project2',
      'can user6 read content on project3',

      'can user7 read content on project1',
      'can user7 read content on project2',
      'can user7 read content on project3',

      'can user8 read content on project1',
      'can user8 read content on project2',
      'can user8 read content on project3',

      'can user9 read content on project1',
      'can user9 read content on project2',
      'can user9 read content on project3',

      'can whoever read content on project2'
    ]);

    expect(results).toEqual({
      'can user1 read content on project1': true,
      'can user1 read content on project2': true,
      'can user1 read content on project3': true,
      'can user1 read content on whattf': null,

      'can user2 read content on project1': true,
      'can user2 read content on project2': false,
      'can user2 read content on project3': true,

      'can user3 read content on project1': true,
      'can user3 read content on project2': false,
      'can user3 read content on project3': true,

      'can user4 read content on project1': true,
      'can user4 read content on project2': false,
      'can user4 read content on project3': false,

      'can user5 read content on project1': true,
      'can user5 read content on project2': false,
      'can user5 read content on project3': true,

      'can user6 read content on project1': true,
      'can user6 read content on project2': false,
      'can user6 read content on project3': false,

      'can user7 read content on project1': false,
      'can user7 read content on project2': false,
      'can user7 read content on project3': true,

      'can user8 read content on project1': true,
      'can user8 read content on project2': false,
      'can user8 read content on project3': false,

      'can user9 read content on project1': false,
      'can user9 read content on project2': false,
      'can user9 read content on project3': false,

      'can whoever read content on project2': null
    });
    expect(results).toMatchSnapshot();

  });
});
