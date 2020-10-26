-- Deploy: schemas/launchql_private/tables/api_tokens/columns/user_id/column to pg
-- made with <3 @ launchql.com

-- requires: schemas/launchql_private/schema
-- requires: schemas/launchql_private/tables/api_tokens/table
-- requires: schemas/launchql_private/tables/api_tokens/columns/id/alterations/alt0000000019

BEGIN;

ALTER TABLE "launchql_private".api_tokens ADD COLUMN user_id uuid;
COMMIT;
