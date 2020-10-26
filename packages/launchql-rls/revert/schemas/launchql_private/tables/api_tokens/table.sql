-- Revert: schemas/launchql_private/tables/api_tokens/table from pg

BEGIN;
DROP TABLE "launchql_rls_private".api_tokens;
COMMIT;  

