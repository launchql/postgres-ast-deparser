-- Deploy: schemas/launchql_private/tables/user_encrypted_secrets/triggers/user_encrypted_secrets_update_tg to pg
-- made with <3 @ launchql.com

-- requires: schemas/launchql_private/schema
-- requires: schemas/launchql_private/tables/user_encrypted_secrets/table
-- requires: schemas/launchql_private/trigger_fns/user_encrypted_secrets_hash

BEGIN;

CREATE TRIGGER user_encrypted_secrets_update_tg
BEFORE UPDATE ON "launchql_private".user_encrypted_secrets
FOR EACH ROW
  WHEN (
    NEW.value IS DISTINCT FROM OLD.value
  )
EXECUTE PROCEDURE "launchql_private".user_encrypted_secrets_hash ();
COMMIT;
