-- Revert: schemas/launchql_public/tables/goals/constraints/goals_name_key from pg

BEGIN;


ALTER TABLE "launchql_rls_public".goals 
    DROP CONSTRAINT goals_name_key;

COMMIT;  

