-- Revert: schemas/launchql_private/trigger_fns/user_encrypted_secrets_hash from pg

BEGIN;


DROP FUNCTION "launchql_rls_private".user_encrypted_secrets_hash;
COMMIT;  

