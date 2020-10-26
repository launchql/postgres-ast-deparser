-- Deploy: schemas/launchql_private/procedures/user_encrypted_secrets_select/procedure to pg
-- made with <3 @ launchql.com

-- requires: schemas/launchql_private/schema
-- requires: schemas/launchql_private/tables/user_encrypted_secrets/table
-- requires: schemas/launchql_private/tables/user_encrypted_secrets/columns/value/column
-- requires: schemas/launchql_private/tables/user_encrypted_secrets/columns/user_id/column
-- requires: schemas/launchql_private/tables/user_encrypted_secrets/triggers/user_encrypted_secrets_insert_tg

BEGIN;

CREATE FUNCTION "launchql_private".user_encrypted_secrets_select (
  user_id uuid,
  secret_name text,
  allow_null boolean default TRUE
)
  RETURNS text
  AS $$
DECLARE
  v_secret "launchql_private".user_encrypted_secrets;
BEGIN
  SELECT
    *
  FROM
    "launchql_private".user_encrypted_secrets s
  WHERE
    s.name = user_encrypted_secrets_select.secret_name
    AND s.user_id = user_encrypted_secrets_select.user_id INTO v_secret;
  IF (NOT FOUND) THEN
    IF (user_encrypted_secrets_select.allow_null) THEN
      RETURN NULL;
    END IF;
    RAISE EXCEPTION 'GENERIC_NO_OBJECT_EXISTS';
  END IF;
  
  IF (v_secret.enc = 'crypt') THEN
    RETURN convert_from(v_secret.value, 'SQL_ASCII');
  ELSIF (v_secret.enc = 'pgp') THEN
    RETURN convert_from(decode(pgp_sym_decrypt(v_secret.value, v_secret.user_id::text), 'hex'), 'SQL_ASCII');
  END IF;
  RETURN convert_from(v_secret.value, 'SQL_ASCII');
END
$$
LANGUAGE 'plpgsql'
STABLE;
COMMIT;
