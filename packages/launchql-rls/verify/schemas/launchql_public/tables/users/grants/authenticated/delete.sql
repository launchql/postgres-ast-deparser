-- Verify: schemas/launchql_public/tables/users/grants/authenticated/delete on pg

BEGIN;
SELECT verify_table_grant('launchql_rls_public.users', 'delete', 'authenticated');
COMMIT;  

