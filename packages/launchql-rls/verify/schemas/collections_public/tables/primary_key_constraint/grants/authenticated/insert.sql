-- Verify: schemas/launchql_rls_launchql_rls_collections_public/tables/primary_key_constraint/grants/authenticated/insert on pg

BEGIN;
SELECT verify_table_grant('launchql_rls_launchql_rls_collections_public.primary_key_constraint', 'insert', 'authenticated');
COMMIT;  

