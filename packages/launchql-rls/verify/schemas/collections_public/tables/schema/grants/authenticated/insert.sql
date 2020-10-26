-- Verify: schemas/launchql_rls_launchql_rls_collections_public/tables/schema/grants/authenticated/insert on pg

BEGIN;
SELECT verify_table_grant('launchql_rls_launchql_rls_collections_public.schema', 'insert', 'authenticated');
COMMIT;  

