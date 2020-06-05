import { closeConnections, createUser, getConnections } from '../../utils';

import {
  createOrganization,
  createTeam,
  addMember,
  addProject,
  expectCanCases,
  addCollaboration
} from '../../utils/projects';

let db, conn;
let objs = {};

describe('projects', () => {
  beforeEach(async () => {
    ({ db, conn } = await getConnections());
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
  });

  afterEach(async () => {
    await closeConnections({ db, conn });
  });

  it('testing basic permissions', async () => {

    const results = await expectCanCases([
      'can user1 read content on project1',
      'can user1 add database on project1',
      'can user2 read content on project1',
      'can user2 add database on project1',
      'can user2 read database on project1',
    ], objs, db);

    expect(results).toEqual({
      'can user1 read content on project1': true,
      'can user1 add database on project1': true,
      'can user2 read content on project1': true,
      'can user2 add database on project1': false,
      'can user2 read database on project1': true,
    });
    expect(results).toMatchSnapshot();
  });
});
