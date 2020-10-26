-- Verify: schemas/launchql_public/tables/users/grants/authenticated/insert on pg

BEGIN;
SELECT verify_table_grant('launchql_rls_public.users', 'insert', 'authenticated');
COMMIT;  

