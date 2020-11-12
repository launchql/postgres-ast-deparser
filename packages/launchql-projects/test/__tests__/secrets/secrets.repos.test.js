import { closeConnections, createUser, getConnections } from '../../utils';

let db, conn;
let objs = {};

async function upsertSecret(conn, project_id, name, value) {
  return await conn.any(
    'SELECT * FROM projects_public.upsert_project_secret($1::uuid, $2::text, $3::text)',
    [project_id, name, value]
  );
}
async function getSecret(conn, project_id, name) {
  return await conn.any(
    'SELECT * FROM projects_private.get_project_secret($1, $2)',
    [project_id, name]
  );
}
async function dropSecret(conn, project_id, name) {
  return await conn.any(
    'SELECT * FROM projects_public.remove_project_secret($1, $2)',
    [project_id, name]
  );
}
async function addRepository(conn, name) {
  return await conn.one(
    'INSERT INTO projects_public.project (name) VALUES ($1) RETURNING *',
    [name]
  );
}

describe('secrets', () => {
  beforeEach(async () => {
    ({ db, conn } = await getConnections());
    objs.user = await createUser(db);
    conn.setContext({
      role: 'authenticated',
      'jwt.claims.user_id': objs.user.id
    });
    objs.proj = await addRepository(conn, 'myproj');
  });
  afterEach(async () => {
    await closeConnections({ db, conn });
  });
  it('insert', async () => {
    const [{ upsert_project_secret: upserted }] = await upsertSecret(
      conn,
      objs.proj.id,
      'MY AMAZING SECRET',
      'boom'
    );
    expect(upserted).toBe(true);
    const secrets = await conn.any(
      'SELECT * FROM projects_private.project_secrets'
    );
    expect(secrets.length).toBe(2);
    const [{ get_project_secret: value }] = await getSecret(
      conn,
      objs.proj.id,
      'MY AMAZING SECRET'
    );
    expect(value).toEqual('boom');
  });
  it('update', async () => {
    const [{ upsert_project_secret: upserted }] = await upsertSecret(
      conn,
      objs.proj.id,
      'MY AMAZING SECRET',
      'boom'
    );
    expect(upserted).toBe(true);
    const [{ upsert_project_secret: upserted2 }] = await upsertSecret(
      conn,
      objs.proj.id,
      'MY AMAZING SECRET',
      'booming'
    );
    expect(upserted2).toBe(true);
    const secrets = await conn.any(
      'SELECT * FROM projects_private.project_secrets'
    );
    expect(secrets.length).toBe(2);
    const [{ get_project_secret: value }] = await getSecret(
      conn,
      objs.proj.id,
      'MY AMAZING SECRET'
    );
    expect(value).toEqual('booming');
  });
  it('delete', async () => {
    const [{ upsert_project_secret: upserted }] = await upsertSecret(
      conn,
      objs.proj.id,
      'MY AMAZING SECRET',
      'boom'
    );
    expect(upserted).toBe(true);
    const [{ remove_project_secret: value }] = await dropSecret(
      conn,
      objs.proj.id,
      'MY AMAZING SECRET'
    );
    expect(value).toBe(true);
    const secrets = await conn.any(
      'SELECT * FROM projects_private.project_secrets'
    );
    expect(secrets.length).toBe(1);
  });
});
