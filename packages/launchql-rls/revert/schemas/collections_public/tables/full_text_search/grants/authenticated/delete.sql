-- Revert: schemas/collections_public/tables/full_text_search/grants/authenticated/delete from pg

BEGIN;
REVOKE DELETE ON TABLE launchql_rls_collections_public.full_text_search FROM authenticated;
COMMIT;  

