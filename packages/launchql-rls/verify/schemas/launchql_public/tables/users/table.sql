-- Verify: schemas/launchql_public/tables/users/table on pg

BEGIN;
SELECT verify_table('launchql_rls_public.users');
COMMIT;  

