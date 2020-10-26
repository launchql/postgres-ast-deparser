-- Verify: schemas/launchql_rls_launchql_rls_collections_public/tables/trigger_function/policies/authenticated_can_delete_on_trigger_function on pg

BEGIN;
SELECT verify_policy('authenticated_can_delete_on_trigger_function', 'launchql_rls_launchql_rls_collections_public.trigger_function');
COMMIT;  

