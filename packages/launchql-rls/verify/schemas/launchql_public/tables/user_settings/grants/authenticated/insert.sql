-- Verify: schemas/launchql_public/tables/user_settings/grants/authenticated/insert on pg

BEGIN;
SELECT verify_table_grant('launchql_rls_public.user_settings', 'insert', 'authenticated');
COMMIT;  

