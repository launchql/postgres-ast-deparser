-- Verify: schemas/launchql_public/tables/user_emails/grants/authenticated/select on pg

BEGIN;
SELECT verify_table_grant('launchql_rls_public.user_emails', 'select', 'authenticated');
COMMIT;  

