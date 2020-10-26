-- Verify: schemas/launchql_rls_launchql_rls_collections_public/tables/unique_constraint/policies/authenticated_can_delete_on_unique_constraint on pg

BEGIN;
SELECT verify_policy('authenticated_can_delete_on_unique_constraint', 'launchql_rls_launchql_rls_collections_public.unique_constraint');
COMMIT;  

