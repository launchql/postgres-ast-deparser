-- Deploy: schemas/launchql_private/tables/api_tokens/columns/id/alterations/alt0000000018 to pg
-- made with <3 @ launchql.com

-- requires: schemas/launchql_private/schema
-- requires: schemas/launchql_private/tables/api_tokens/table
-- requires: schemas/launchql_private/tables/api_tokens/columns/id/column

BEGIN;

ALTER TABLE "launchql_private".api_tokens 
    ALTER COLUMN id SET NOT NULL;
COMMIT;
