-- Verify: schemas/launchql_rls_launchql_rls_collections_public/tables/unique_constraint/grants/authenticated/select on pg

BEGIN;
SELECT verify_table_grant('launchql_rls_launchql_rls_collections_public.unique_constraint', 'select', 'authenticated');
COMMIT;  
