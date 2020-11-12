import { closeConnections, createUser, getConnections } from '../../utils';

let db, conn, organization, user;

const insertBucket = async (owner_id, organization_id) => {
  return await conn.one(
    `
      INSERT INTO files_public.buckets
        (
          name,
          owner_id,
          organization_id
        ) VALUES ($1, $2, $3)
        RETURNING *`,
    [
      name,
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
      'jwt.claims.user_id': user.id
    });
    organization = await conn.one(
      'SELECT * FROM roles_public.register_organization($1)',
      ['my amazing organization']
    );
  });
  afterEach(async () => {
    await closeConnections({ db, conn });
  });
  it('insert bucket for self', async () => {
    const bucket = await insertBucket(user.id, user.id);
    console.log(bucket);
    expect(bucket).toBeTruthy();
  });
  it('insert bucket for organization', async () => {
    const bucket = await insertBucket(user.id, organization.id);
    console.log(bucket);
    expect(bucket).toBeTruthy();
  });
});
