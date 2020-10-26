-- Revert: schemas/collections_public/tables/trigger/policies/authenticated_can_update_on_trigger from pg

BEGIN;
DROP POLICY authenticated_can_update_on_trigger ON launchql_rls_collections_public.trigger;
COMMIT;  

