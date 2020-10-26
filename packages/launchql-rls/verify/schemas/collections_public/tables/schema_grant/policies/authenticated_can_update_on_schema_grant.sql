-- Verify: schemas/launchql_rls_launchql_rls_collections_public/tables/schema_grant/policies/authenticated_can_update_on_schema_grant on pg

BEGIN;
SELECT verify_policy('authenticated_can_update_on_schema_grant', 'launchql_rls_launchql_rls_collections_public.schema_grant');
COMMIT;  

