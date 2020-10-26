-- Verify: schemas/launchql_rls_launchql_rls_collections_public/tables/policy/grants/authenticated/select on pg

BEGIN;
SELECT verify_table_grant('launchql_rls_launchql_rls_collections_public.policy', 'select', 'authenticated');
COMMIT;  

