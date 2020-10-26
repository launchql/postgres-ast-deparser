-- Revert: schemas/collections_public/tables/procedure/policies/authenticated_can_update_on_procedure from pg

BEGIN;
DROP POLICY authenticated_can_update_on_procedure ON launchql_rls_collections_public.procedure;
COMMIT;  

