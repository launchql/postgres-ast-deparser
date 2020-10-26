-- Revert: schemas/launchql_private/tables/api_tokens/columns/id/alterations/alt0000000018 from pg

BEGIN;


ALTER TABLE "launchql_rls_private".api_tokens 
    ALTER COLUMN id DROP NOT NULL;


COMMIT;  

