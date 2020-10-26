-- Revert: schemas/launchql_public/tables/goals/columns/id/column from pg

BEGIN;


ALTER TABLE "launchql_rls_public".goals DROP COLUMN id;
COMMIT;  

