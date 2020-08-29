import { getConnections, closeConnections, createUser } from '../../utils';

let db, conn, user;

describe('roles_public.forgot_password()', () => {
  beforeEach(async () => {
    ({ db, conn } = await getConnections());
  });
  beforeEach(async () => {
    user = await createUser(db);
  });
  afterEach(async () => {
    await closeConnections({ db, conn });
  });
  describe('forgot_password logic', () => {
    it('has secrets on creation', async () => {
      const email = await db.one(
        'SELECT * FROM roles_public.user_emails WHERE role_id = $1',
        [user.id]
      );
      expect(email).toBeTruthy();
      const emailSecret = await db.one(
        'SELECT * FROM roles_private.user_email_secrets WHERE user_email_id = $1',
        [email.id]
      );
      const userSecret = await db.one(
        'SELECT * FROM roles_private.user_secrets WHERE role_id = $1',
        [user.id]
      );
      expect(emailSecret).toBeTruthy();
      expect(emailSecret.verification_token).toBeFalsy();
      expect(emailSecret.password_reset_email_sent_at).toBeFalsy();

      expect(userSecret).toBeTruthy();
      expect(userSecret.reset_password_token).toBeFalsy();
      expect(userSecret.reset_password_token_generated).toBeFalsy();
      expect(userSecret.reset_password_attempts).toBe(0);
      expect(userSecret.first_failed_reset_password_attempt).toBeFalsy();
    });
    it('forgot_password', async () => {
      const success = await conn.one(
        'SELECT * FROM roles_public.forgot_password($1)',
        [user.email]
      );
      expect(success).toBeTruthy();

      const email = await db.one(
        'SELECT * FROM roles_public.user_emails WHERE role_id = $1',
        [user.id]
      );
      expect(email).toBeTruthy();

      const job = await db.one('SELECT * FROM app_jobs.jobs LIMIT 1');

      expect(job).toBeTruthy();
      expect(job.payload).toBeTruthy();
      expect(job.payload.id).toEqual(user.id);
      expect(job.payload.email).toEqual(user.email);

      const emailSecret = await db.one(
        'SELECT * FROM roles_private.user_email_secrets WHERE user_email_id = $1',
        [email.id]
      );

      expect(emailSecret).toBeTruthy();
      expect(emailSecret.password_reset_email_sent_at).toBeTruthy();

      const userSecret = await db.one(
        'SELECT * FROM roles_private.user_secrets WHERE role_id = $1',
        [user.id]
      );

      expect(userSecret).toBeTruthy();
      expect(userSecret.reset_password_token).toBeTruthy();
      expect(userSecret.reset_password_token_generated).toBeTruthy();
      expect(userSecret.reset_password_attempts).toBe(0);
      expect(userSecret.first_failed_reset_password_attempt).toBeFalsy();
    });
  });
  describe('multiple forgot_password attempts', () => {
    it('forgot_password', async () => {
      for (let i = 0; i < 20; i++) {
        await conn.one('SELECT * FROM roles_public.forgot_password($1)', [
          user.email
        ]);
      }

      const jobs = await db.any('SELECT * FROM app_jobs.jobs');

      expect(jobs).toBeTruthy();
      expect(jobs.length).toBe(1);
    });
  });
});
