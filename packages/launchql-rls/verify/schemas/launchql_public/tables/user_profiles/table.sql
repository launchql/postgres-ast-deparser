-- Verify: schemas/launchql_public/tables/user_profiles/table on pg

BEGIN;
SELECT verify_table('launchql_rls_public.user_profiles');
COMMIT;  

