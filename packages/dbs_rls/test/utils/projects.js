import { createUser } from './index';

export async function createOrganization(conn, name) {
  return await conn.one(
    'SELECT * FROM roles_public.register_organization($1)',
    [name]
  );
}

export async function createTeam(conn, name, organization_id, parent_id) {
  return await conn.one(
    'SELECT * FROM roles_public.register_team($1, $2, $3)',
    [name, organization_id, parent_id]
  );
}

export async function addMember(conn, role_id, group_id, profile_id, organization_id) {
  await conn.any(
    'INSERT INTO roles_public.memberships (role_id, group_id, profile_id, organization_id) VALUES ($1, $2, $3, $4)',
    [role_id, group_id, profile_id, organization_id]
  );
}

export async function addProject(conn, name, owner_id) {
  return await conn.one(
    `INSERT INTO projects_public.project
    (name, owner_id)
    VALUES ($1, $2) RETURNING *`,
    [name, owner_id]
  );
}

export async function addCollaboration(
  conn, role_id,
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


export async function can(opts, db) {
  const { permitted_on_project: res } = await db.one(
    'SELECT collaboration_private.permitted_on_project($1, $2, $3, $4)',
    [opts.action_type, opts.object_type, opts.project_id, opts.actor_id]
  );
  return res;
}

const makeCase = (name, objs) => {
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

export async function expectCanCases(cases, objs, db) {
  const madeCases = cases.map(c => makeCase(c, objs));

  const results = {};
  for (let cs of madeCases) {
    await (async cs => {
      results[cs.name] = await can(cs, db);
    })(cs);
  }
  return results;
}

export async function twoUsersAndProject({ db, conn, objs }) {

  objs.user1 = await createUser(db, undefined, 'user1');
  objs.user2 = await createUser(db, undefined, 'user2');

  conn.setContext({
    role: 'authenticated',
    'jwt.claims.role_id': objs.user1.id
  });

  objs.org1 = await createOrganization(conn, 'org1');

  objs.profiles = await db.many('SELECT * FROM permissions_public.profile');
  objs.permissions = await db.many('SELECT * FROM permissions_public.permission');
  objs.profiles = objs.profiles.reduce((m, profile) => {
    m[profile.organization_id] = m[profile.organization_id] || {};
    m[profile.organization_id][profile.name] = profile;
    return m;
  }, {});

  objs.project1 = await addProject(conn, 'project1', objs.org1.id);
  objs.teamA = await createTeam(conn, 'teamA', objs.org1.id);

  await addMember(
    conn,
    objs.user2.id,
    objs.teamA.id,
    objs.profiles[objs.org1.id].Member.id,
    objs.org1.id
  );


  await addCollaboration(
    conn,
    objs.teamA.id,
    objs.profiles[objs.org1.id].Member.id,
    objs.project1.id,
    objs.project1.owner_id
  );


  objs.projects = {
    [objs.project1.id]: objs.project1,
  };
}