-- Revert: schemas/collections_public/tables/schema/policies/authenticated_can_insert_on_schema from pg

BEGIN;
DROP POLICY authenticated_can_insert_on_schema ON launchql_rls_collections_public.schema;
COMMIT;  

