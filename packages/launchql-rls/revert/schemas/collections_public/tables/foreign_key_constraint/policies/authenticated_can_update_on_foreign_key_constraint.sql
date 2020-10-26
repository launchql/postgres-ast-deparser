-- Revert: schemas/collections_public/tables/foreign_key_constraint/policies/authenticated_can_update_on_foreign_key_constraint from pg

BEGIN;
DROP POLICY authenticated_can_update_on_foreign_key_constraint ON launchql_rls_collections_public.foreign_key_constraint;
COMMIT;  

