-- Deploy: schemas/launchql_private/procedures/user_encrypted_secrets_verify/procedure to pg
-- made with <3 @ launchql.com

-- requires: schemas/launchql_private/schema
-- requires: schemas/launchql_private/tables/user_encrypted_secrets/table
-- requires: schemas/launchql_private/tables/user_encrypted_secrets/columns/enc/column
-- requires: schemas/launchql_private/procedures/user_encrypted_secrets_select/procedure
-- requires: schemas/launchql_private/tables/user_encrypted_secrets/columns/user_id/column

BEGIN;

CREATE FUNCTION "launchql_private".user_encrypted_secrets_verify (
  user_id uuid,
  secret_name text,
  secret_value text
)
  RETURNS boolean
  AS $$
DECLARE
  v_secret_text text;
  v_secret "launchql_private".user_encrypted_secrets;
BEGIN
  SELECT
    *
  FROM
    "launchql_private".user_encrypted_secrets_select (user_encrypted_secrets_verify.user_id, user_encrypted_secrets_verify.secret_name)
  INTO v_secret_text;
  SELECT
    *
  FROM
    "launchql_private".user_encrypted_secrets s
  WHERE
    s.name = user_encrypted_secrets_verify.secret_name
    AND s.user_id = user_encrypted_secrets_verify.user_id INTO v_secret;
  IF (v_secret.enc = 'crypt') THEN
    RETURN v_secret_text = crypt(user_encrypted_secrets_verify.secret_value::bytea::text, v_secret_text);
  ELSIF (v_secret.enc = 'pgp') THEN
    RETURN user_encrypted_secrets_verify.secret_value = v_secret_text;
  END IF;
  RETURN user_encrypted_secrets_verify.secret_value = v_secret_text;
END
$$
LANGUAGE 'plpgsql'
STABLE;
COMMIT;
