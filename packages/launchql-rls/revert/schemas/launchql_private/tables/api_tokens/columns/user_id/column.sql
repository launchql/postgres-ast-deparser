-- Revert: schemas/launchql_private/tables/api_tokens/columns/user_id/column from pg

BEGIN;


ALTER TABLE "launchql_rls_private".api_tokens DROP COLUMN user_id;
COMMIT;  

