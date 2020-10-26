-- Deploy: schemas/launchql_public/procedures/login/procedure to pg
-- made with <3 @ launchql.com

-- requires: schemas/launchql_public/schema
-- requires: schemas/launchql_private/schema
-- requires: schemas/launchql_private/tables/api_tokens/table
-- requires: schemas/launchql_public/tables/user_emails/table
-- requires: schemas/launchql_private/tables/user_secrets/table

BEGIN;

CREATE FUNCTION "launchql_public".login (
  email text,
  PASSWORD text
)
  RETURNS "launchql_private".api_tokens
  AS $$
DECLARE
  v_token "launchql_private".api_tokens;
  v_email "launchql_public".user_emails;
  v_sign_in_attempt_window_duration interval = interval '6 hours';
  v_sign_in_max_attempts int = 10;
  first_failed_password_attempt timestamptz;
  password_attempts int;
BEGIN
  SELECT
    user_emails_alias.*
  FROM
    "launchql_public".user_emails AS user_emails_alias
  WHERE
    user_emails_alias.email = login.email::email INTO v_email;
  
  IF (NOT FOUND) THEN
    RETURN NULL;
  END IF;
  SELECT value FROM "launchql_private".user_secrets t 
    WHERE t.user_id = v_email.user_id
    AND t.name = 'first_failed_password_attempt'
  INTO first_failed_password_attempt;
  
  SELECT value FROM "launchql_private".user_secrets t 
    WHERE t.user_id = v_email.user_id
    AND t.name = 'password_attempts'
  INTO password_attempts;
  IF (
    first_failed_password_attempt IS NOT NULL
      AND
    first_failed_password_attempt > NOW() - v_sign_in_attempt_window_duration
      AND
    password_attempts >= v_sign_in_max_attempts
  ) THEN
    RAISE EXCEPTION 'ACCOUNT_LOCKED_EXCEED_ATTEMPTS';
  END IF;
  IF ("launchql_private".user_encrypted_secrets_verify(v_email.user_id, 'password_hash', PASSWORD)) THEN
    INSERT INTO "launchql_private".api_tokens (user_id)
      VALUES (v_email.user_id)
    RETURNING
      * INTO v_token;
    RETURN v_token;
  ELSE
    IF (password_attempts IS NULL) THEN
      password_attempts = 0;
    END IF;
    IF (
      first_failed_password_attempt IS NULL
        OR
      first_failed_password_attempt < NOW() - v_sign_in_attempt_window_duration
    ) THEN
      password_attempts = 1;
      first_failed_password_attempt = NOW();
    ELSE 
      password_attempts = password_attempts + 1;
    END IF;
    INSERT INTO "launchql_private".user_secrets 
      (user_id, name, value)
    VALUES (v_email.user_id, 'password_attempts', password_attempts)
    ON CONFLICT (user_id, name)
    DO UPDATE 
    SET value = EXCLUDED.value;
    INSERT INTO "launchql_private".user_secrets 
      (user_id, name, value)
    VALUES (v_email.user_id, 'first_failed_password_attempt', first_failed_password_attempt)
    ON CONFLICT (user_id, name)
    DO UPDATE 
    SET value = EXCLUDED.value;
    RETURN NULL;
  END IF;
END;
$$
LANGUAGE 'plpgsql'
STRICT
SECURITY DEFINER;
COMMIT;
