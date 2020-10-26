-- Verify: schemas/launchql_rls_launchql_rls_collections_public/tables/index/policies/authenticated_can_update_on_index on pg

BEGIN;
SELECT verify_policy('authenticated_can_update_on_index', 'launchql_rls_launchql_rls_collections_public.index');
COMMIT;  

