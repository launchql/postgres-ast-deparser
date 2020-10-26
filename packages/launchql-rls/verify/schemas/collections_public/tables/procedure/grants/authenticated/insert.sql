-- Verify: schemas/launchql_rls_launchql_rls_collections_public/tables/procedure/grants/authenticated/insert on pg

BEGIN;
SELECT verify_table_grant('launchql_rls_launchql_rls_collections_public.procedure', 'insert', 'authenticated');
COMMIT;  

