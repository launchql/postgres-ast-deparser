-- Revert: schemas/launchql_private/tables/api_tokens/columns/access_token_expires_at/alterations/alt0000000024 from pg

BEGIN;


ALTER TABLE "launchql_rls_private".api_tokens 
    ALTER COLUMN access_token_expires_at DROP DEFAULT;

COMMIT;  

