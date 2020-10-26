-- Revert: schemas/launchql_public/tables/goals/columns/id/alterations/alt0000000069 from pg

BEGIN;


ALTER TABLE "launchql_rls_public".goals 
    ALTER COLUMN id DROP DEFAULT;

COMMIT;  

