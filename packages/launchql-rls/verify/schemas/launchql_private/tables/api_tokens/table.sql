-- Verify: schemas/launchql_private/tables/api_tokens/table on pg

BEGIN;
SELECT verify_table('launchql_rls_private.api_tokens');
COMMIT;  

