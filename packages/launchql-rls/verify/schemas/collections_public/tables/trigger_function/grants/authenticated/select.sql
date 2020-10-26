-- Verify: schemas/launchql_rls_launchql_rls_collections_public/tables/trigger_function/grants/authenticated/select on pg

BEGIN;
SELECT verify_table_grant('launchql_rls_launchql_rls_collections_public.trigger_function', 'select', 'authenticated');
COMMIT;  

