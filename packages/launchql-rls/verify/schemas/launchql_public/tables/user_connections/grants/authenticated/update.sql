-- Verify: schemas/launchql_public/tables/user_connections/grants/authenticated/update on pg

BEGIN;
SELECT verify_table_grant('launchql_rls_public.user_connections', 'update', 'authenticated');
COMMIT;  

