import { closeConnections, createUser, getConnections } from '../../utils';

let db, conn;
let objs = {};

async function addRepository(conn, name) {
  return await conn.one(
    'INSERT INTO projects_public.project (name) VALUES ($1) RETURNING *',
    [name]
  );
}

describe('content', () => {
  beforeEach(async () => {
    ({ db, conn } = await getConnections());
    objs.user = await createUser(db);
    conn.setContext({
      role: 'authenticated',
      'jwt.claims.role_id': objs.user.id
    });
    objs.proj = await addRepository(conn, 'myproj');
  });
  afterEach(async () => {
    await closeConnections({ db, conn });
  });
  it('works', async () => {
    const tag = await conn.one(
      `INSERT INTO content_public.tag
          (project_id, slug, name)
        VALUES
          ($1, $2, $3)
        RETURNING *`,
      [objs.proj.id, 'mytag', 'mytag']
    );
    const content = await conn.one(
      `INSERT INTO content_public.content
          (project_id, slug, title)
        VALUES
          ($1, $2, $3)
        RETURNING *`,
      [objs.proj.id, 'slug', 'slug']
    );
    const contentTag = await conn.one(
      `INSERT INTO content_public.content_tag
          (project_id, content_id, tag_id)
        VALUES
          ($1, $2, $3)
        RETURNING *`,
      [objs.proj.id, content.id, tag.id]
    );
    console.log({ content, tag, contentTag });
  });
  it('publish', async () => {
    const content = await conn.one(
      `INSERT INTO content_public.content
          (project_id, slug, title)
        VALUES
          ($1, $2, $3)
        RETURNING *`,
      [objs.proj.id, 'slug', 'slug']
    );
    const updated = await conn.one(
      `UPDATE content_public.content
      SET status='published'
      WHERE id=$1
      RETURNING *`,
      [content.id]
    );

    console.log({ content, updated });
  });
});
