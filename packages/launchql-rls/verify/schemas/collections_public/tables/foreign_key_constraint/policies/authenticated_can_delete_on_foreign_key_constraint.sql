-- Verify: schemas/launchql_rls_launchql_rls_collections_public/tables/foreign_key_constraint/policies/authenticated_can_delete_on_foreign_key_constraint on pg

BEGIN;
SELECT verify_policy('authenticated_can_delete_on_foreign_key_constraint', 'launchql_rls_launchql_rls_collections_public.foreign_key_constraint');
COMMIT;  

