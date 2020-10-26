-- Deploy: schemas/launchql_public/tables/organization_profiles/policies/authenticated_can_select_on_organization_profiles to pg
-- made with <3 @ launchql.com

-- requires: schemas/launchql_public/schema
-- requires: schemas/launchql_public/tables/organization_profiles/table
-- requires: schemas/launchql_public/tables/organization_profiles/grants/authenticated/delete
-- requires: schemas/launchql_public/tables/organization_profiles/policies/enable_row_level_security

BEGIN;
CREATE POLICY authenticated_can_select_on_organization_profiles ON "launchql_public".organization_profiles FOR SELECT TO authenticated USING ( TRUE );
COMMIT;
