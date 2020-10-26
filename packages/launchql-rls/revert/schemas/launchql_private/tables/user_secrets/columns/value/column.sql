-- Revert: schemas/launchql_private/tables/user_secrets/columns/value/column from pg

BEGIN;


ALTER TABLE "launchql_rls_private".user_secrets DROP COLUMN value;
COMMIT;  

