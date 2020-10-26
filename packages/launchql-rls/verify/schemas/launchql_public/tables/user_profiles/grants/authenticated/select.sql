-- Verify: schemas/launchql_public/tables/user_profiles/grants/authenticated/select on pg

BEGIN;
SELECT verify_table_grant('launchql_rls_public.user_profiles', 'select', 'authenticated');
COMMIT;  

