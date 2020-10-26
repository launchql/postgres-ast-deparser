-- Verify: schemas/launchql_public/tables/users/grants/authenticated/select on pg

BEGIN;
SELECT verify_table_grant('launchql_rls_public.users', 'select', 'authenticated');
COMMIT;  

