-- Deploy: schemas/launchql_public/tables/organization_profiles/grants/authenticated/update to pg
-- made with <3 @ launchql.com

-- requires: schemas/launchql_public/schema
-- requires: schemas/launchql_public/tables/organization_profiles/table
-- requires: schemas/launchql_public/tables/organization_profiles/grants/authenticated/insert

BEGIN;
GRANT UPDATE ON TABLE "launchql_public".organization_profiles TO authenticated;
COMMIT;
