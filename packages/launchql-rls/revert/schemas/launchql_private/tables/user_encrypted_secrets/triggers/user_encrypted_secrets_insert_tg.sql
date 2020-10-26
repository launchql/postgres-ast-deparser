-- Revert: schemas/launchql_private/tables/user_encrypted_secrets/triggers/user_encrypted_secrets_insert_tg from pg

BEGIN;


DROP TRIGGER user_encrypted_secrets_insert_tg
    ON "launchql_rls_private".user_encrypted_secrets;
COMMIT;  

