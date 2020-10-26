-- Revert: schemas/launchql_public/tables/goals/constraints/goals_pkey from pg

BEGIN;


ALTER TABLE "launchql_rls_public".goals 
    DROP CONSTRAINT goals_pkey;

COMMIT;  

