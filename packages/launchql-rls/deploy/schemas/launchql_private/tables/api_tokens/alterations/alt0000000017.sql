-- Deploy: schemas/launchql_private/tables/api_tokens/alterations/alt0000000017 to pg
-- made with <3 @ launchql.com

-- requires: schemas/launchql_private/schema
-- requires: schemas/launchql_private/tables/api_tokens/table

BEGIN;

ALTER TABLE "launchql_private".api_tokens
    DISABLE ROW LEVEL SECURITY;
COMMIT;
