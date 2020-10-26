-- Verify: schemas/launchql_rls_launchql_rls_collections_public/tables/rls_function/grants/authenticated/select on pg

BEGIN;
SELECT verify_table_grant('launchql_rls_launchql_rls_collections_public.rls_function', 'select', 'authenticated');
COMMIT;  

