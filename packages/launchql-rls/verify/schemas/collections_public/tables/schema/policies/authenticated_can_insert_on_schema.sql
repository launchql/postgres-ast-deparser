-- Verify: schemas/launchql_rls_launchql_rls_collections_public/tables/schema/policies/authenticated_can_insert_on_schema on pg

BEGIN;
SELECT verify_policy('authenticated_can_insert_on_schema', 'launchql_rls_launchql_rls_collections_public.schema');
COMMIT;  

