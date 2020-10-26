-- Revert: schemas/launchql_public/tables/goals/columns/id/alterations/alt0000000068 from pg

BEGIN;


ALTER TABLE "launchql_rls_public".goals 
    ALTER COLUMN id DROP NOT NULL;


COMMIT;  

