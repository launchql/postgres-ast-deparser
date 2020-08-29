import { closeConnections, createUser, getConnections } from '../../utils';

let db, conn, organization, user;

const insertFile = async (owner_id, organization_id) => {
  return await conn.one(
    `
      INSERT INTO files_public.files
        (
          id,
          filename,
          mimetype,
          encoding,
          sha1,
          etag,
          size,
          key,
          url,
          owner_id,
          organization_id
        ) VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11)
        RETURNING *`,
    [
      '01eb7595-9e8f-4497-9128-6bdb3d52d2fd',
      'my.jpg',
      'image/jpg',
      'ascii',
      'sha1',
      'etag',
      10101,
      'my.jpg',
      'http://s3.com/my.jpg',
      owner_id,
      organization_id,
    ]
  );
};

describe('uploads', () => {
  beforeEach(async () => {
    ({ db, conn } = await getConnections());
    user = await createUser(db);
    conn.setContext({
      role: 'authenticated',
      'jwt.claims.role_id': user.id
    });
    organization = await conn.one(
      'SELECT * FROM roles_public.register_organization($1)',
      ['my amazing organization']
    );
  });
  afterEach(async () => {
    await closeConnections({ db, conn });
  });
  it('insert file for self', async () => {
    const file = await insertFile(user.id, user.id);
    console.log(file);
    expect(file).toBeTruthy();
  });
  it('insert file for organization', async () => {
    const file = await insertFile(user.id, organization.id);
    console.log(file);
    expect(file).toBeTruthy();
  });
});
