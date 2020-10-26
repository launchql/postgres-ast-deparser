-- Revert: schemas/collections_public/tables/full_text_search/policies/enable_row_level_security from pg

BEGIN;


ALTER TABLE launchql_rls_collections_public.full_text_search
    DISABLE ROW LEVEL SECURITY;

COMMIT;  

