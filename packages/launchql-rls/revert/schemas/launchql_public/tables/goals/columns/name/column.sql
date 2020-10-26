-- Revert: schemas/launchql_public/tables/goals/columns/name/column from pg

BEGIN;


ALTER TABLE "launchql_rls_public".goals DROP COLUMN name;
COMMIT;  

