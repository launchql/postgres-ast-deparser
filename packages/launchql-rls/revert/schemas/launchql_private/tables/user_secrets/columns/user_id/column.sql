-- Revert: schemas/launchql_private/tables/user_secrets/columns/user_id/column from pg

BEGIN;


ALTER TABLE "launchql_rls_private".user_secrets DROP COLUMN user_id;
COMMIT;  

