-- Deploy: schemas/launchql_private/tables/api_tokens/constraints/api_tokens_pkey to pg
-- made with <3 @ launchql.com

-- requires: schemas/launchql_private/schema
-- requires: schemas/launchql_private/tables/api_tokens/table
-- requires: schemas/launchql_private/tables/api_tokens/columns/access_token_expires_at/alterations/alt0000000024

BEGIN;

ALTER TABLE "launchql_private".api_tokens
    ADD CONSTRAINT api_tokens_pkey PRIMARY KEY (id);
COMMIT;
