-- Deploy: schemas/launchql_public/tables/organization_profiles/policies/authenticated_can_update_on_organization_profiles to pg
-- made with <3 @ launchql.com

-- requires: schemas/launchql_public/schema
-- requires: schemas/launchql_public/tables/organization_profiles/table
-- requires: schemas/launchql_public/tables/organization_profiles/policies/enable_row_level_security
-- requires: schemas/launchql_public/tables/organization_profiles/policies/authenticated_can_insert_on_organization_profiles

BEGIN;
CREATE POLICY authenticated_can_update_on_organization_profiles ON "launchql_public".organization_profiles FOR UPDATE TO authenticated USING ( organization_id = "launchql_public".get_current_user_id() );
COMMIT;
