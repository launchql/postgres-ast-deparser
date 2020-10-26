-- Verify: schemas/launchql_public/tables/goals/indexes/goals_vector_index on pg

BEGIN;
SELECT verify_index('launchql_rls_public.goals', 'goals_vector_index');
COMMIT;  

