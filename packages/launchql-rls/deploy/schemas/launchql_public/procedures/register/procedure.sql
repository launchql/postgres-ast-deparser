-- Deploy: schemas/launchql_public/procedures/register/procedure to pg
-- made with <3 @ launchql.com

-- requires: schemas/launchql_public/schema
-- requires: schemas/launchql_private/schema
-- requires: schemas/launchql_public/tables/users/table
-- requires: schemas/launchql_private/tables/api_tokens/table
-- requires: schemas/launchql_public/tables/user_emails/table
-- requires: schemas/launchql_public/procedures/login/procedure

BEGIN;

CREATE FUNCTION "launchql_public".register (
  email text,
  password text
)
  RETURNS "launchql_private".api_tokens
  AS $$
DECLARE
  v_user "launchql_public".users;
  v_email "launchql_public".user_emails;
  v_token "launchql_private".api_tokens;
BEGIN
  SELECT * FROM "launchql_public".user_emails t
    WHERE trim(register.email)::email = t.email
  INTO v_email;
  IF (NOT FOUND) THEN
    INSERT INTO "launchql_public".users
      DEFAULT VALUES
    RETURNING
      * INTO v_user;
    INSERT INTO "launchql_public".user_emails (user_id, email)
      VALUES (v_user.id, trim(register.email))
    RETURNING
      * INTO v_email;
    INSERT INTO "launchql_private".api_tokens (user_id)
      VALUES (v_user.id)
    RETURNING
      * INTO v_token;
    PERFORM "launchql_private".user_encrypted_secrets_upsert(v_user.id, 'password_hash', password, 'crypt');
    RETURN v_token;
  END IF;
  RAISE EXCEPTION 'ACCOUNT_EXISTS';
END;
$$
LANGUAGE plpgsql
VOLATILE
SECURITY DEFINER;
COMMIT;
