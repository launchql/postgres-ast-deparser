-- Revert: schemas/collections_public/tables/rls_function/policies/authenticated_can_select_on_rls_function from pg

BEGIN;
DROP POLICY authenticated_can_select_on_rls_function ON launchql_rls_collections_public.rls_function;
COMMIT;  

