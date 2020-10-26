-- Revert: schemas/launchql_public/tables/goals/columns/search/column from pg

BEGIN;


ALTER TABLE "launchql_rls_public".goals DROP COLUMN search;
COMMIT;  

