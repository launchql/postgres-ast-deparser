-- Verify: schemas/launchql_rls_launchql_rls_collections_public/tables/schema_grant/grants/authenticated/insert on pg

BEGIN;
SELECT verify_table_grant('launchql_rls_launchql_rls_collections_public.schema_grant', 'insert', 'authenticated');
COMMIT;  

