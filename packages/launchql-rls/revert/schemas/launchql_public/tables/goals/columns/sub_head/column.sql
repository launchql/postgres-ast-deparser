-- Revert: schemas/launchql_public/tables/goals/columns/sub_head/column from pg

BEGIN;


ALTER TABLE "launchql_rls_public".goals DROP COLUMN sub_head;
COMMIT;  

