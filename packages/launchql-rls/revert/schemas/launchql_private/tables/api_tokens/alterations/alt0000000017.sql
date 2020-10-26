-- Revert: schemas/launchql_private/tables/api_tokens/alterations/alt0000000017 from pg

BEGIN;


ALTER TABLE "launchql_rls_private".api_tokens
    ENABLE ROW LEVEL SECURITY;

COMMIT;  

