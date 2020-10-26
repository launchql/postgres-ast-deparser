-- Verify: schemas/launchql_rls_launchql_rls_collections_public/tables/table_grant/grants/authenticated/delete on pg

BEGIN;
SELECT verify_table_grant('launchql_rls_launchql_rls_collections_public.table_grant', 'delete', 'authenticated');
COMMIT;  

