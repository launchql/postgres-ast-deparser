-- Verify: schemas/launchql_rls_launchql_rls_collections_public/tables/full_text_search/grants/authenticated/insert on pg

BEGIN;
SELECT verify_table_grant('launchql_rls_launchql_rls_collections_public.full_text_search', 'insert', 'authenticated');
COMMIT;  

