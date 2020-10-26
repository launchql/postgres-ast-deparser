-- Revert: schemas/launchql_public/tables/goals/policies/authenticated_can_select_on_goals from pg

BEGIN;
DROP POLICY authenticated_can_select_on_goals ON "launchql_rls_public".goals;
COMMIT;  

