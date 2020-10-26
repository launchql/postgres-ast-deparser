-- Deploy: schemas/launchql_private/tables/api_tokens/columns/access_token_expires_at/column to pg
-- made with <3 @ launchql.com

-- requires: schemas/launchql_private/schema
-- requires: schemas/launchql_private/tables/api_tokens/table
-- requires: schemas/launchql_private/tables/api_tokens/columns/access_token/alterations/alt0000000022

BEGIN;

ALTER TABLE "launchql_private".api_tokens ADD COLUMN access_token_expires_at timestamptz;
COMMIT;
