-- Deploy: schemas/launchql_private/tables/api_tokens/columns/user_id/alterations/alt0000000020 to pg
-- made with <3 @ launchql.com

-- requires: schemas/launchql_private/schema
-- requires: schemas/launchql_private/tables/api_tokens/table
-- requires: schemas/launchql_private/tables/api_tokens/columns/user_id/column

BEGIN;

ALTER TABLE "launchql_private".api_tokens 
    ALTER COLUMN user_id SET NOT NULL;
COMMIT;
