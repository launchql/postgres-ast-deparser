-- Verify: schemas/launchql_rls_launchql_rls_collections_public/tables/primary_key_constraint/policies/authenticated_can_select_on_primary_key_constraint on pg

BEGIN;
SELECT verify_policy('authenticated_can_select_on_primary_key_constraint', 'launchql_rls_launchql_rls_collections_public.primary_key_constraint');
COMMIT;  

