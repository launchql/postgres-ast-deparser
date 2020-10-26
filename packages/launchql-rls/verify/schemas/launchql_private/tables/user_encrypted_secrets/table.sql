-- Verify: schemas/launchql_private/tables/user_encrypted_secrets/table on pg

BEGIN;
SELECT verify_table('launchql_rls_private.user_encrypted_secrets');
COMMIT;  

