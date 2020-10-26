-- Revert: schemas/launchql_public/tables/goals/table from pg

BEGIN;
DROP TABLE "launchql_rls_public".goals;
COMMIT;  

