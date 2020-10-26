-- Revert: schemas/collections_public/tables/trigger_function/policies/authenticated_can_update_on_trigger_function from pg

BEGIN;
DROP POLICY authenticated_can_update_on_trigger_function ON launchql_rls_collections_public.trigger_function;
COMMIT;  

