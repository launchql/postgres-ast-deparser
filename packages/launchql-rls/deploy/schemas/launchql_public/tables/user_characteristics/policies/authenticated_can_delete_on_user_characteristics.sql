-- Deploy: schemas/launchql_public/tables/user_characteristics/policies/authenticated_can_delete_on_user_characteristics to pg
-- made with <3 @ launchql.com

-- requires: schemas/launchql_public/schema
-- requires: schemas/launchql_public/tables/user_characteristics/table
-- requires: schemas/launchql_public/tables/user_characteristics/policies/enable_row_level_security
-- requires: schemas/launchql_public/tables/user_characteristics/policies/authenticated_can_update_on_user_characteristics

BEGIN;
CREATE POLICY authenticated_can_delete_on_user_characteristics ON "launchql_public".user_characteristics FOR DELETE TO authenticated USING ( user_id = "launchql_public".get_current_user_id() );
COMMIT;
