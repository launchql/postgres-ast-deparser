-- Revert: schemas/launchql_private/tables/user_encrypted_secrets/table from pg

BEGIN;
DROP TABLE "launchql_rls_private".user_encrypted_secrets;
COMMIT;  

