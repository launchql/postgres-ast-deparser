-- Deploy: schemas/launchql_private/tables/api_tokens/grants/authenticated/update to pg
-- made with <3 @ launchql.com

-- requires: schemas/launchql_private/schema
-- requires: schemas/launchql_private/tables/api_tokens/table
-- requires: schemas/launchql_private/tables/api_tokens/grants/authenticated/insert

BEGIN;
GRANT UPDATE ON TABLE "launchql_private".api_tokens TO authenticated;
COMMIT;
