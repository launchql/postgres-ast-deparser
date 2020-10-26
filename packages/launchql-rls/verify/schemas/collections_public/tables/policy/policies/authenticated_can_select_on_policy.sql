-- Verify: schemas/launchql_rls_launchql_rls_collections_public/tables/policy/policies/authenticated_can_select_on_policy on pg

BEGIN;
SELECT verify_policy('authenticated_can_select_on_policy', 'launchql_rls_launchql_rls_collections_public.policy');
COMMIT;  

