import { closeConnections, createUser, getConnections } from '../../utils';

const moment = require('node-moment');

let db, conn, user;

describe('roles_public.sign_in()', () => {
  beforeEach(async () => {
    ({ db, conn } = await getConnections());
  });
  beforeEach(async () => {
    user = await createUser(db);
  });
  afterEach(async () => {
    await closeConnections({ db, conn });
  });
  describe('totp', () => {
    beforeEach(async () => {
      conn.setContext({
        role: 'authenticated',
        'jwt.claims.role_id': user.id
      });
      await conn.any(
        'SELECT * FROM auth_private.set_multi_factor_secret(\'abcdef\')',
        ['abcdef', user.id]
      );
      conn.setContext({});
    });
    it('sign_in 2fa', async () => {
      const token = await conn.one(
        'SELECT * FROM roles_public.sign_in($1, $2)',
        [user.email, user.password]
      );
      expect(token).toBeTruthy();
      expect(token.type).toEqual('totp');
      expect(token.access_token).toBeTruthy();
      expect(token.refresh_token).toBeFalsy();
      const tok = await conn.any(
        'SELECT * FROM auth_private.authenticate($1::text)',
        [token.access_token]
      );
      expect(tok.length).toBe(1);
      expect(tok[0].type).toEqual('totp');
      db.setContext({
        'jwt.claims.access_token': token.access_token
      });
      const mfa = await db.one(
        'SELECT * FROM auth_private.multi_factor_auth($1)',
        [true]
      );
      expect(mfa).toBeTruthy();
      expect(mfa.type).toEqual('auth');
    });
  });
  describe('sign_in logic', () => {
    it('sign_in', async () => {
      const token = await conn.one(
        'SELECT * FROM roles_public.sign_in($1, $2)',
        [user.email, user.password]
      );
      expect(token).toBeTruthy();
    });
    it('access_token_expires_at', async () => {
      const token = await conn.one(
        'SELECT * FROM roles_public.sign_in($1, $2)',
        [user.email, user.password]
      );
      const { now: nowDate } = await conn.one('SELECT NOW()::timestamptz');

      expect(token.role_id).toEqual(user.id);
      expect(token.access_token).toBeTruthy();
      expect(token.refresh_token).toBeTruthy();
      expect(token.access_token_expires_at).toBeTruthy();

      const now = moment(nowDate);
      const expires = moment(token.access_token_expires_at);
      const minutesTillExpires = expires.diff(now, 'minutes');
      expect(minutesTillExpires).toBe(359);
    });
  });
  describe('bad sign_in logic', () => {
    it('cannot sign in after 10 bad attempts', async () => {
      for (let i = 0; i < 10; i++) {
        await conn.one('SELECT * FROM roles_public.sign_in($1, $2)', [
          user.email,
          'wrongpassword'
        ]);
      }
      let failed = false;
      try {
        await conn.one('SELECT * FROM roles_public.sign_in($1, $2)', [
          user.email,
          user.password
        ]);
      } catch (e) {
        expect(e.message).toEqual(
          'ACCOUNT_LOCKED_EXCEED_ATTEMPTS'
        );
        failed = true;
      }
      expect(failed).toBe(true);
      const secretAfter = await db.one(
        'SELECT * FROM roles_private.user_secrets WHERE role_id=$1',
        [user.id]
      );
      expect(secretAfter).toBeTruthy();
      expect(secretAfter.password_attempts).toBe(10);
      expect(secretAfter.first_failed_password_attempt).toBeTruthy();
    });
    it('can sign in after 9 bad attempts', async () => {
      for (let i = 0; i < 9; i++) {
        await conn.one('SELECT * FROM roles_public.sign_in($1, $2)', [
          user.email,
          'wrongpassword'
        ]);
      }
      let failed = false;
      let token = null;
      try {
        token = await conn.one('SELECT * FROM roles_public.sign_in($1, $2)', [
          user.email,
          user.password
        ]);
      } catch (e) {
        failed = true;
      }
      expect(failed).toBe(false);
      expect(token).toBeTruthy();
      const secretAfter = await db.one(
        'SELECT * FROM roles_private.user_secrets WHERE role_id=$1',
        [user.id]
      );
      expect(secretAfter).toBeTruthy();
      expect(secretAfter.password_attempts).toBe(0);
      expect(secretAfter.first_failed_password_attempt).toBeFalsy();
    });
  });
});
