-- Verify: schemas/launchql_rls_launchql_rls_collections_public/tables/rls_function/policies/authenticated_can_delete_on_rls_function on pg

BEGIN;
SELECT verify_policy('authenticated_can_delete_on_rls_function', 'launchql_rls_launchql_rls_collections_public.rls_function');
COMMIT;  

