-- Deploy: schemas/launchql_private/tables/api_tokens/policies/enable_row_level_security to pg
-- made with <3 @ launchql.com

-- requires: schemas/launchql_private/schema
-- requires: schemas/launchql_private/tables/api_tokens/table
-- requires: schemas/launchql_private/tables/user_secrets/grants/authenticated/delete

BEGIN;

ALTER TABLE "launchql_private".api_tokens
    ENABLE ROW LEVEL SECURITY;
COMMIT;
