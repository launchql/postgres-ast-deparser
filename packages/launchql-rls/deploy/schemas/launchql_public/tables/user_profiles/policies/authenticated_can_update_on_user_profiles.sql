-- Deploy: schemas/launchql_public/tables/user_profiles/policies/authenticated_can_update_on_user_profiles to pg
-- made with <3 @ launchql.com

-- requires: schemas/launchql_public/schema
-- requires: schemas/launchql_public/tables/user_profiles/table
-- requires: schemas/launchql_public/tables/user_profiles/policies/enable_row_level_security
-- requires: schemas/launchql_public/tables/user_profiles/policies/authenticated_can_insert_on_user_profiles

BEGIN;
CREATE POLICY authenticated_can_update_on_user_profiles ON "launchql_public".user_profiles FOR UPDATE TO authenticated USING ( user_id = "launchql_public".get_current_user_id() );
COMMIT;
