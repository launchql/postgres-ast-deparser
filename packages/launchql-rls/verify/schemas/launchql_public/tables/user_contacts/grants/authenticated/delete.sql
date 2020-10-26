-- Verify: schemas/launchql_public/tables/user_contacts/grants/authenticated/delete on pg

BEGIN;
SELECT verify_table_grant('launchql_rls_public.user_contacts', 'delete', 'authenticated');
COMMIT;  

