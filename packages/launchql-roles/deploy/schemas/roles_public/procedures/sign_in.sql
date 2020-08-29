-- Deploy schemas/roles_public/procedures/sign_in to pg
-- requires: schemas/roles_public/schema
-- requires: schemas/auth_private/tables/token/table
-- requires: schemas/auth_private/types/token_type
-- requires: schemas/roles_public/tables/user_emails/table
-- requires: schemas/roles_private/tables/user_secrets/table

BEGIN;
CREATE FUNCTION roles_public.sign_in (
  email text,
  PASSWORD text
)
  RETURNS auth_private.token
  AS $$
DECLARE
  secret roles_private.user_secrets;
  v_token auth_private.token;
  v_email roles_public.user_emails;
  v_sign_in_attempt_window_duration interval = interval '6 hours';
  v_sign_in_max_attempts int = 10;
BEGIN
  SELECT
    user_email.*
  FROM
    roles_public.user_emails AS user_email
  WHERE
    user_email.email = sign_in.email::email INTO v_email;
  -- NOT FOUND
  IF (NOT FOUND) THEN
    RETURN NULL;
  END IF;
  -- get secrets
  SELECT
    st.*
  FROM
    roles_private.user_secrets AS st
  WHERE
    st.role_id = v_email.role_id INTO secret;
  IF (NOT FOUND) THEN
    RETURN NULL;
  END IF;
  IF (secret.first_failed_password_attempt IS NOT NULL AND secret.first_failed_password_attempt > NOW() - v_sign_in_attempt_window_duration AND secret.password_attempts >= v_sign_in_max_attempts) THEN
    RAISE EXCEPTION 'ACCOUNT_LOCKED_EXCEED_ATTEMPTS';
  END IF;
  IF secret.password_hash = crypt(PASSWORD, secret.password_hash) THEN
    -- green light! login...

    -- NOT yet verified
    IF (NOT v_email.is_verified) THEN
      RAISE EXCEPTION 'EMAIL_NOT_VERIFIED';
    END IF;

    -- reset the attempts
    UPDATE
      roles_private.user_secrets
    SET
      password_attempts = 0,
      first_failed_password_attempt = NULL
    WHERE
      role_id = v_email.role_id;
    
    -- create a token
    INSERT INTO auth_private.token (TYPE, role_id)
      VALUES ('auth'::auth_private.token_type, secret.role_id)
    RETURNING
      * INTO v_token;

    -- return the token
    RETURN v_token;
  ELSE
    -- bad login!
    UPDATE
      roles_private.user_secrets
    SET
      password_attempts = (
        CASE WHEN first_failed_password_attempt IS NULL
          OR first_failed_password_attempt < NOW() - v_sign_in_attempt_window_duration THEN
          1
        ELSE
          password_attempts + 1
        END),
      first_failed_password_attempt = (
        CASE WHEN first_failed_password_attempt IS NULL
          OR first_failed_password_attempt < NOW() - v_sign_in_attempt_window_duration THEN
          NOW()
        ELSE
          first_failed_password_attempt
        END)
    WHERE
      role_id = v_email.role_id;
    RETURN NULL;
  END IF;
END;
$$
LANGUAGE 'plpgsql'
STRICT
SECURITY DEFINER;
GRANT EXECUTE ON FUNCTION roles_public.sign_in TO anonymous;
COMMIT;

