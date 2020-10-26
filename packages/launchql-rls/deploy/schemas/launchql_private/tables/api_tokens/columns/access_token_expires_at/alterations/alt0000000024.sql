-- Deploy: schemas/launchql_private/tables/api_tokens/columns/access_token_expires_at/alterations/alt0000000024 to pg
-- made with <3 @ launchql.com

-- requires: schemas/launchql_private/schema
-- requires: schemas/launchql_private/tables/api_tokens/table
-- requires: schemas/launchql_private/tables/api_tokens/columns/access_token_expires_at/column
-- requires: schemas/launchql_private/tables/api_tokens/columns/access_token_expires_at/alterations/alt0000000023

BEGIN;

ALTER TABLE "launchql_private".api_tokens 
    ALTER COLUMN access_token_expires_at SET DEFAULT (NOW() + interval '30 days');
COMMIT;
