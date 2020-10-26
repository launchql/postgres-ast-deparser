-- Revert: schemas/collections_public/tables/index/policies/authenticated_can_select_on_index from pg

BEGIN;
DROP POLICY authenticated_can_select_on_index ON launchql_rls_collections_public.index;
COMMIT;  

