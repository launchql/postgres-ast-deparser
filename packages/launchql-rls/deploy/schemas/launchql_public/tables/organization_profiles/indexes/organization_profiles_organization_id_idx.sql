-- Deploy: schemas/launchql_public/tables/organization_profiles/indexes/organization_profiles_organization_id_idx to pg
-- made with <3 @ launchql.com

-- requires: schemas/launchql_public/schema
-- requires: schemas/launchql_public/tables/organization_profiles/table
-- requires: schemas/launchql_public/tables/organization_profiles/constraints/organization_profiles_organization_id_fkey

BEGIN;

CREATE INDEX organization_profiles_organization_id_idx ON "launchql_public".organization_profiles (organization_id);
COMMIT;
