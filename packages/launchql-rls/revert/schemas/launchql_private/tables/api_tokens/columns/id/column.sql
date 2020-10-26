-- Revert: schemas/launchql_private/tables/api_tokens/columns/id/column from pg

BEGIN;


ALTER TABLE "launchql_rls_private".api_tokens DROP COLUMN id;
COMMIT;  

