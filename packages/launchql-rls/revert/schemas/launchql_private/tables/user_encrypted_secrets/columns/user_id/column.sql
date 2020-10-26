-- Revert: schemas/launchql_private/tables/user_encrypted_secrets/columns/user_id/column from pg

BEGIN;


ALTER TABLE "launchql_rls_private".user_encrypted_secrets DROP COLUMN user_id;
COMMIT;  

