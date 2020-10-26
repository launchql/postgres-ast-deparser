-- Revert: schemas/launchql_private/tables/user_secrets/columns/name/column from pg

BEGIN;


ALTER TABLE "launchql_rls_private".user_secrets DROP COLUMN name;
COMMIT;  

