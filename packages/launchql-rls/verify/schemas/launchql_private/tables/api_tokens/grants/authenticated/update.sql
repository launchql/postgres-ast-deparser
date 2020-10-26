-- Verify: schemas/launchql_private/tables/api_tokens/grants/authenticated/update on pg

BEGIN;
SELECT verify_table_grant('launchql_rls_private.api_tokens', 'update', 'authenticated');
COMMIT;  

