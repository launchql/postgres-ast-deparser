-- Revert: schemas/launchql_public/tables/goals/columns/icon/column from pg

BEGIN;


ALTER TABLE "launchql_rls_public".goals DROP COLUMN icon;
COMMIT;  

