-- Revert: schemas/launchql_public/tables/goals/columns/short_name/column from pg

BEGIN;


ALTER TABLE "launchql_rls_public".goals DROP COLUMN short_name;
COMMIT;  

