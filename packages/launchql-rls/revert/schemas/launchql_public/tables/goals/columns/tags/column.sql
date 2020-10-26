-- Revert: schemas/launchql_public/tables/goals/columns/tags/column from pg

BEGIN;


ALTER TABLE "launchql_rls_public".goals DROP COLUMN tags;
COMMIT;  

