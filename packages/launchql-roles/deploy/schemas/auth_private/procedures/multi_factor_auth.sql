-- Deploy schemas/auth_private/procedures/multi_factor_auth to pg

-- requires: schemas/auth_private/schema
-- requires: schemas/roles_private/tables/user_secrets/table
-- requires: schemas/auth_private/tables/token/table
-- requires: schemas/auth_private/types/token_type
-- requires: schemas/auth_private/procedures/current_token

BEGIN;

CREATE FUNCTION auth_private.multi_factor_auth(
  verified boolean
) returns auth_private.token as $$
DECLARE
secret roles_private.user_secrets;
current_token auth_private.token;
token auth_private.token;
mfa_attempt_window_duration interval = interval '1 hours';
mfa_max_attempts int = 5;
BEGIN

  SELECT * FROM auth_private.current_token()
    INTO current_token;

  IF (current_token.type != 'totp'::auth_private.token_type) THEN
    RETURN NULL;
  END IF;

  SELECT st.* FROM roles_private.user_secrets AS st
    WHERE st.role_id = current_token.role_id
    INTO secret;

  IF (NOT FOUND) THEN
    RETURN NULL;
  END IF;

  IF (secret.first_failed_multi_factor_attempt is not null
    AND secret.first_failed_multi_factor_attempt > NOW() - mfa_attempt_window_duration
    AND secret.multi_factor_attempts >= mfa_max_attempts) THEN
      RAISE EXCEPTION 'ACCOUNT_LOCKED_EXCEED_MFA_ATTEMPTS';
  END IF;

  IF verified THEN
    -- green light! login...
    -- reset the attempts
    UPDATE roles_private.user_secrets scts
      SET multi_factor_attempts = 0, first_failed_multi_factor_attempt = null
      WHERE scts.role_id = current_token.role_id;

    INSERT INTO auth_private.token (type, role_id)
    VALUES ('auth'::auth_private.token_type, secret.role_id)
    RETURNING
      *
    INTO token;

    RETURN token;
  ELSE
    -- bad login!
    UPDATE roles_private.user_secrets scts
      SET
        multi_factor_attempts = (CASE WHEN first_failed_multi_factor_attempt is NULL OR first_failed_multi_factor_attempt < NOW() - mfa_attempt_window_duration THEN 1 ELSE multi_factor_attempts + 1 END),
        first_failed_multi_factor_attempt = (CASE WHEN first_failed_multi_factor_attempt is NULL OR first_failed_multi_factor_attempt < NOW() - mfa_attempt_window_duration THEN NOW() ELSE first_failed_multi_factor_attempt END)
      WHERE scts.role_id = current_token.role_id;

    RETURN NULL;
  END IF;

END;
$$
LANGUAGE 'plpgsql' STRICT
SECURITY DEFINER;

COMMENT ON FUNCTION auth_private.multi_factor_auth IS
'Upon success, should return a login auth_private.token';

COMMIT;
