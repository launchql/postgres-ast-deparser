-- Verify: schemas/launchql_rls_launchql_rls_collections_public/tables/full_text_search/policies/authenticated_can_delete_on_full_text_search on pg

BEGIN;
SELECT verify_policy('authenticated_can_delete_on_full_text_search', 'launchql_rls_launchql_rls_collections_public.full_text_search');
COMMIT;  

