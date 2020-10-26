-- Revert: schemas/collections_public/tables/field/policies/authenticated_can_delete_on_field from pg

BEGIN;
DROP POLICY authenticated_can_delete_on_field ON launchql_rls_collections_public.field;
COMMIT;  

