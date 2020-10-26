-- Deploy: schemas/launchql_private/tables/user_secrets/policies/authenticated_can_delete_on_user_secrets to pg
-- made with <3 @ launchql.com

-- requires: schemas/launchql_private/schema
-- requires: schemas/launchql_private/tables/user_secrets/table
-- requires: schemas/launchql_private/tables/user_secrets/policies/enable_row_level_security
-- requires: schemas/launchql_private/tables/user_secrets/policies/authenticated_can_update_on_user_secrets

BEGIN;
CREATE POLICY authenticated_can_delete_on_user_secrets ON "launchql_private".user_secrets FOR DELETE TO authenticated USING ( user_id = "launchql_public".get_current_user_id() );
COMMIT;
