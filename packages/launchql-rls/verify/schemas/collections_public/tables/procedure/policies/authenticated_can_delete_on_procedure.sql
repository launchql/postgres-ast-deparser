-- Verify: schemas/launchql_rls_launchql_rls_collections_public/tables/procedure/policies/authenticated_can_delete_on_procedure on pg

BEGIN;
SELECT verify_policy('authenticated_can_delete_on_procedure', 'launchql_rls_launchql_rls_collections_public.procedure');
COMMIT;  

