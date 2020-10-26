-- Verify: schemas/launchql_public/tables/user_connections/table on pg

BEGIN;
SELECT verify_table('launchql_rls_public.user_connections');
COMMIT;  

