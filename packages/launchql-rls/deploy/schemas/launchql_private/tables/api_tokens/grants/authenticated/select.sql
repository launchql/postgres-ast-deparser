-- Deploy: schemas/launchql_private/tables/api_tokens/grants/authenticated/select to pg
-- made with <3 @ launchql.com

-- requires: schemas/launchql_private/schema
-- requires: schemas/launchql_private/tables/api_tokens/table
-- requires: schemas/launchql_private/tables/api_tokens/policies/authenticated_can_delete_on_api_tokens

BEGIN;
GRANT SELECT ON TABLE "launchql_private".api_tokens TO authenticated;
COMMIT;
