-- Verify: schemas/launchql_public/tables/goals/grants/authenticated/select on pg

BEGIN;
SELECT verify_table_grant('launchql_rls_public.goals', 'select', 'authenticated');
COMMIT;  

