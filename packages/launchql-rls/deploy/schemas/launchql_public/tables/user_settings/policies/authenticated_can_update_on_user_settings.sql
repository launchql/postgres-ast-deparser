-- Deploy: schemas/launchql_public/tables/user_settings/policies/authenticated_can_update_on_user_settings to pg
-- made with <3 @ launchql.com

-- requires: schemas/launchql_public/schema
-- requires: schemas/launchql_public/tables/user_settings/table
-- requires: schemas/launchql_public/tables/user_settings/policies/enable_row_level_security
-- requires: schemas/launchql_public/tables/user_settings/policies/authenticated_can_insert_on_user_settings

BEGIN;
CREATE POLICY authenticated_can_update_on_user_settings ON "launchql_public".user_settings FOR UPDATE TO authenticated USING ( user_id = "launchql_public".get_current_user_id() );
COMMIT;
