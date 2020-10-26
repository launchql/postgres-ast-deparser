-- Verify: schemas/launchql_public/tables/goals/table on pg

BEGIN;
SELECT verify_table('launchql_rls_public.goals');
COMMIT;  

