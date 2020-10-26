-- Verify: schemas/launchql_rls_launchql_rls_collections_public/tables/field/policies/authenticated_can_delete_on_field on pg

BEGIN;
SELECT verify_policy('authenticated_can_delete_on_field', 'launchql_rls_launchql_rls_collections_public.field');
COMMIT;  

