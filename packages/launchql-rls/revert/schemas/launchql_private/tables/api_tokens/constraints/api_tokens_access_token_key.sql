-- Revert: schemas/launchql_private/tables/api_tokens/constraints/api_tokens_access_token_key from pg

BEGIN;


ALTER TABLE "launchql_rls_private".api_tokens 
    DROP CONSTRAINT api_tokens_access_token_key;

COMMIT;  

