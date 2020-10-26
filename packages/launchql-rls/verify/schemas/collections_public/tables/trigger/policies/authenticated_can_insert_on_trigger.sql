-- Verify: schemas/launchql_rls_launchql_rls_collections_public/tables/trigger/policies/authenticated_can_insert_on_trigger on pg

BEGIN;
SELECT verify_policy('authenticated_can_insert_on_trigger', 'launchql_rls_launchql_rls_collections_public.trigger');
COMMIT;  

