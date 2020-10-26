-- Deploy: schemas/launchql_public/tables/organization_profiles/policies/enable_row_level_security to pg
-- made with <3 @ launchql.com

-- requires: schemas/launchql_public/schema
-- requires: schemas/launchql_public/tables/organization_profiles/table
-- requires: schemas/launchql_public/tables/organization_profiles/constraints/organization_profiles_organization_id_key

BEGIN;

ALTER TABLE "launchql_public".organization_profiles
    ENABLE ROW LEVEL SECURITY;
COMMIT;
