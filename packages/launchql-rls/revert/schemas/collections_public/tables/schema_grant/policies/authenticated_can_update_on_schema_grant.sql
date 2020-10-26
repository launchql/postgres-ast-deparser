-- Revert: schemas/collections_public/tables/schema_grant/policies/authenticated_can_update_on_schema_grant from pg

BEGIN;
DROP POLICY authenticated_can_update_on_schema_grant ON launchql_rls_collections_public.schema_grant;
COMMIT;  

