-- Deploy: schemas/launchql_private/tables/api_tokens/policies/authenticated_can_delete_on_api_tokens to pg
-- made with <3 @ launchql.com

-- requires: schemas/launchql_private/schema
-- requires: schemas/launchql_private/tables/api_tokens/table
-- requires: schemas/launchql_private/tables/api_tokens/policies/enable_row_level_security
-- requires: schemas/launchql_private/tables/api_tokens/policies/authenticated_can_update_on_api_tokens

BEGIN;
CREATE POLICY authenticated_can_delete_on_api_tokens ON "launchql_private".api_tokens FOR DELETE TO authenticated USING ( user_id = "launchql_public".get_current_user_id() );
COMMIT;
