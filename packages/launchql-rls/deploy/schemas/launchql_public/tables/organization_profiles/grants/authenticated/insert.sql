-- Deploy: schemas/launchql_public/tables/organization_profiles/grants/authenticated/insert to pg
-- made with <3 @ launchql.com

-- requires: schemas/launchql_public/schema
-- requires: schemas/launchql_public/tables/organization_profiles/table
-- requires: schemas/launchql_public/tables/organization_profiles/policies/authenticated_can_delete_on_organization_profiles

BEGIN;
GRANT INSERT ON TABLE "launchql_public".organization_profiles TO authenticated;
COMMIT;
