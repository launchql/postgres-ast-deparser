-- Verify: schemas/launchql_rls_launchql_rls_collections_public/tables/index/grants/authenticated/select on pg

BEGIN;
SELECT verify_table_grant('launchql_rls_launchql_rls_collections_public.index', 'select', 'authenticated');
COMMIT;  
