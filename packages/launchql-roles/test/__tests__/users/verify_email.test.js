import { getConnections, closeConnections, createUser } from '../../utils';

let db, conn, user;

describe('roles_public.verify_email()', () => {
  beforeEach(async () => {
    ({ db, conn } = await getConnections());
    user = await createUser(db);
  });
  afterEach(async () => {
    await closeConnections({ db, conn });
  });
  describe('verify logic', () => {
    it('has secrets on creation', async () => {
      conn.setContext({
        role: 'authenticated',
        'jwt.claims.user_id': user.id
      });
      const email = 'dude@gmail.com';

      const userEmail = await conn.one(
        'INSERT INTO roles_public.user_emails (email) VALUES ($1) RETURNING *',
        [email]
      );

      const userEmailSecrets = await db.one(
        'SELECT * FROM roles_private.user_email_secrets WHERE user_email_id = $1',
        [userEmail.id]
      );

      expect(userEmail).toEqual(
        expect.objectContaining({
          email,
          is_verified: false
        })
      );
      expect(userEmailSecrets).toEqual(
        expect.objectContaining({
          verification_token: expect.any(String),
          password_reset_email_sent_at: null
        })
      );

      const verifyEmail = await conn.one(
        'SELECT * FROM roles_public.verify_email($1::uuid, $2::text)',
        [userEmail.id, userEmailSecrets.verification_token]
      );

      expect(verifyEmail).toEqual(
        expect.objectContaining({
          verify_email: true
        })
      );

      const userEmailAfterVerification = await conn.one(
        'SELECT * FROM roles_public.user_emails WHERE email=$1',
        [email]
      );

      expect(userEmailAfterVerification).toEqual(
        expect.objectContaining({
          is_verified: true
        })
      );
    });
  });
});
