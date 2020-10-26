-- Deploy: schemas/launchql_private/tables/api_tokens/constraints/api_tokens_access_token_key to pg
-- made with <3 @ launchql.com

-- requires: schemas/launchql_private/schema
-- requires: schemas/launchql_private/tables/api_tokens/table
-- requires: schemas/launchql_private/tables/api_tokens/constraints/api_tokens_pkey

BEGIN;

ALTER TABLE "launchql_private".api_tokens
    ADD CONSTRAINT api_tokens_access_token_key UNIQUE (access_token);
COMMIT;
