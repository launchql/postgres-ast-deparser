import { getConnections, closeConnections, createUser } from '../../utils';

let db, conn, user;

describe('roles_public.reset_password()', () => {
  beforeEach(async () => {
    ({ db, conn } = await getConnections());
  });
  beforeEach(async () => {
    user = await createUser(db);
  });
  afterEach(async () => {
    await closeConnections({ db, conn });
  });
  describe('reset_password logic', () => {
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
    it('reset_password', async () => {
      await conn.one(
        'SELECT * FROM roles_public.forgot_password($1)',
        [user.email]
      );
      const email = await db.one(
        'SELECT * FROM roles_public.user_emails WHERE role_id = $1',
        [user.id]
      );
      await db.one('SELECT * FROM app_jobs.jobs LIMIT 1');
      const emailSecret = await db.one(
        'SELECT * FROM roles_private.user_email_secrets WHERE user_email_id = $1',
        [email.id]
      );
      const userSecret = await db.one(
        'SELECT * FROM roles_private.user_secrets WHERE role_id = $1',
        [user.id]
      );

      await conn.one(
        'SELECT * FROM roles_public.reset_password($1, $2, $3)',
        [user.id, userSecret.reset_password_token, 'mynewpassword']
      );

      const emailSecretAfter = await db.one(
        'SELECT * FROM roles_private.user_email_secrets WHERE user_email_id = $1',
        [email.id]
      );
      const userSecretAfter = await db.one(
        'SELECT * FROM roles_private.user_secrets WHERE role_id = $1',
        [user.id]
      );

      // email secrets dont change
      expect(emailSecretAfter).toBeTruthy();
      expect(emailSecretAfter.verification_token).toBeFalsy();
      expect(emailSecretAfter.password_reset_email_sent_at).toBeTruthy();
      expect(emailSecret).toBeTruthy();
      expect(emailSecret.verification_token).toBeFalsy();
      expect(emailSecret.password_reset_email_sent_at).toBeTruthy();

      // resets all the secrets
      expect(userSecretAfter).toBeTruthy();
      expect(userSecretAfter.reset_password_token).toBeFalsy();
      expect(userSecretAfter.reset_password_token_generated).toBeFalsy();
      expect(userSecretAfter.reset_password_attempts).toBe(0);
      expect(userSecretAfter.first_failed_reset_password_attempt).toBeFalsy();
    });
  });
  describe('bad reset_password logic', () => {
    it('reset_password', async () => {
      await conn.one(
        'SELECT * FROM roles_public.forgot_password($1)',
        [user.email]
      );
      const email = await db.one(
        'SELECT * FROM roles_public.user_emails WHERE role_id = $1',
        [user.id]
      );
      await db.one('SELECT * FROM app_jobs.jobs LIMIT 1');
      const emailSecret = await db.one(
        'SELECT * FROM roles_private.user_email_secrets WHERE user_email_id = $1',
        [email.id]
      );
      await db.one(
        'SELECT * FROM roles_private.user_secrets WHERE role_id = $1',
        [user.id]
      );

      for (let i = 0; i < 10; i++) {
        await conn.one(
          'SELECT * FROM roles_public.reset_password($1, $2, $3)',
          [user.id, 'badtoken', 'mynewpassword']
        );
      }
      let failed = false;
      try {
        await conn.one(
          'SELECT * FROM roles_public.reset_password($1, $2, $3)',
          [user.id, 'badtoken', 'mynewpassword']
        );
      } catch (e) {
        expect(e.message).toEqual(
          'PASSWORD_RESET_LOCKED_EXCEED_ATTEMPTS'
        );
        failed = true;
      }

      expect(failed).toBe(true);

      const emailSecretAfter = await db.one(
        'SELECT * FROM roles_private.user_email_secrets WHERE user_email_id = $1',
        [email.id]
      );
      const userSecretAfter = await db.one(
        'SELECT * FROM roles_private.user_secrets WHERE role_id = $1',
        [user.id]
      );

      // email secrets dont change
      expect(emailSecretAfter).toBeTruthy();
      expect(emailSecretAfter.verification_token).toBeFalsy();
      expect(emailSecretAfter.password_reset_email_sent_at).toBeTruthy();
      expect(emailSecret).toBeTruthy();
      expect(emailSecret.verification_token).toBeFalsy();
      expect(emailSecret.password_reset_email_sent_at).toBeTruthy();

      // resets all the secrets
      expect(userSecretAfter).toBeTruthy();
      expect(userSecretAfter.reset_password_token).toBeTruthy();
      expect(userSecretAfter.reset_password_token_generated).toBeTruthy();
      expect(userSecretAfter.reset_password_attempts).toBe(10);
      expect(userSecretAfter.first_failed_reset_password_attempt).toBeTruthy();
    });
  });
});
