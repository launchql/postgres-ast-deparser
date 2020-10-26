-- Revert: schemas/launchql_private/tables/user_encrypted_secrets/columns/value/column from pg

BEGIN;


ALTER TABLE "launchql_rls_private".user_encrypted_secrets DROP COLUMN value;
COMMIT;  

