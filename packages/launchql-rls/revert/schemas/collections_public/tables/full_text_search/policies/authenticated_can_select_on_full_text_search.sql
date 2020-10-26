-- Revert: schemas/collections_public/tables/full_text_search/policies/authenticated_can_select_on_full_text_search from pg

BEGIN;
DROP POLICY authenticated_can_select_on_full_text_search ON launchql_rls_collections_public.full_text_search;
COMMIT;  

