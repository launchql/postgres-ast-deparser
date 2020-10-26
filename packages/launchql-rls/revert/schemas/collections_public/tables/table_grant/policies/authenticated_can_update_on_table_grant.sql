-- Revert: schemas/collections_public/tables/table_grant/policies/authenticated_can_update_on_table_grant from pg

BEGIN;
DROP POLICY authenticated_can_update_on_table_grant ON launchql_rls_collections_public.table_grant;
COMMIT;  

