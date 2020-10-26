-- Verify: schemas/launchql_public/tables/goals/policies/authenticated_can_select_on_goals on pg

BEGIN;
SELECT verify_policy('authenticated_can_select_on_goals', 'launchql_rls_public.goals');
COMMIT;  

