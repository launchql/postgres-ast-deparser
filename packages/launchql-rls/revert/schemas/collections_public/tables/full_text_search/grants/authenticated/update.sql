-- Revert: schemas/collections_public/tables/full_text_search/grants/authenticated/update from pg

BEGIN;
REVOKE UPDATE ON TABLE launchql_rls_collections_public.full_text_search FROM authenticated;
COMMIT;  

