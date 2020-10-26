-- Revert: schemas/collections_public/tables/primary_key_constraint/policies/authenticated_can_delete_on_primary_key_constraint from pg

BEGIN;
DROP POLICY authenticated_can_delete_on_primary_key_constraint ON launchql_rls_collections_public.primary_key_constraint;
COMMIT;  

