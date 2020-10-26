-- Revert: schemas/launchql_private/tables/api_tokens/columns/access_token/alterations/alt0000000021 from pg

BEGIN;


ALTER TABLE "launchql_rls_private".api_tokens 
    ALTER COLUMN access_token DROP NOT NULL;


COMMIT;  

