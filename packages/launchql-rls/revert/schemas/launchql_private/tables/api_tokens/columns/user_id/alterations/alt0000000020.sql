-- Revert: schemas/launchql_private/tables/api_tokens/columns/user_id/alterations/alt0000000020 from pg

BEGIN;


ALTER TABLE "launchql_rls_private".api_tokens 
    ALTER COLUMN user_id DROP NOT NULL;


COMMIT;  

