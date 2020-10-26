-- Verify: schemas/launchql_public/tables/users/grants/authenticated/update on pg

BEGIN;
SELECT verify_table_grant('launchql_rls_public.users', 'update', 'authenticated');
COMMIT;  

