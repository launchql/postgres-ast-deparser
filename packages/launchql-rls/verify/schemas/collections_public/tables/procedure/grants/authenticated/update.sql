-- Verify: schemas/launchql_rls_launchql_rls_collections_public/tables/procedure/grants/authenticated/update on pg

BEGIN;
SELECT verify_table_grant('launchql_rls_launchql_rls_collections_public.procedure', 'update', 'authenticated');
COMMIT;  

