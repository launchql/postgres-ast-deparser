-- Deploy: schemas/launchql_private/tables/api_tokens/columns/id/alterations/alt0000000019 to pg
-- made with <3 @ launchql.com

-- requires: schemas/launchql_private/schema
-- requires: schemas/launchql_private/tables/api_tokens/table
-- requires: schemas/launchql_private/tables/api_tokens/columns/id/column
-- requires: schemas/launchql_private/tables/api_tokens/columns/id/alterations/alt0000000018

BEGIN;

ALTER TABLE "launchql_private".api_tokens 
    ALTER COLUMN id SET DEFAULT "launchql_private".uuid_generate_v4();
COMMIT;
