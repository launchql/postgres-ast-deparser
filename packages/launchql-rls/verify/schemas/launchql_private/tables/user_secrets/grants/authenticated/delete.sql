-- Verify: schemas/launchql_private/tables/user_secrets/grants/authenticated/delete on pg

BEGIN;
SELECT verify_table_grant('launchql_rls_private.user_secrets', 'delete', 'authenticated');
COMMIT;  

