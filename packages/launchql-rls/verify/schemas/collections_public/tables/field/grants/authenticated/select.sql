-- Verify: schemas/launchql_rls_launchql_rls_collections_public/tables/field/grants/authenticated/select on pg

BEGIN;
SELECT verify_table_grant('launchql_rls_launchql_rls_collections_public.field', 'select', 'authenticated');
COMMIT;  

