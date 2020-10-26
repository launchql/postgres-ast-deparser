-- Deploy: schemas/launchql_private/procedures/user_encrypted_secrets_upsert/procedure to pg
-- made with <3 @ launchql.com

-- requires: schemas/launchql_private/schema
-- requires: schemas/launchql_private/tables/user_encrypted_secrets/table
-- requires: schemas/launchql_private/tables/user_encrypted_secrets/columns/enc/column
-- requires: schemas/launchql_private/procedures/user_encrypted_secrets_verify/procedure
-- requires: schemas/launchql_private/tables/user_encrypted_secrets/columns/value/column
-- requires: schemas/launchql_private/tables/user_encrypted_secrets/columns/user_id/column

BEGIN;

CREATE FUNCTION "launchql_private".user_encrypted_secrets_upsert (
  v_user_id uuid,
  secret_name text,
  secret_value text,
  field_encoding text = 'pgp'
)
  RETURNS boolean
  AS $$
BEGIN
  INSERT INTO "launchql_private".user_encrypted_secrets (user_id, name, value, enc)
    VALUES (v_user_id, user_encrypted_secrets_upsert.secret_name, user_encrypted_secrets_upsert.secret_value::bytea, user_encrypted_secrets_upsert.field_encoding)
    ON CONFLICT (user_id, name)
    DO
    UPDATE
    SET
      value = EXCLUDED.value;
  RETURN TRUE;
END
$$
LANGUAGE 'plpgsql'
VOLATILE;
COMMIT;
