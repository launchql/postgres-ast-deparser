-- Revert: schemas/collections_public/tables/unique_constraint/policies/authenticated_can_insert_on_unique_constraint from pg

BEGIN;
DROP POLICY authenticated_can_insert_on_unique_constraint ON launchql_rls_collections_public.unique_constraint;
COMMIT;  

