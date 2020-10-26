-- Deploy: schemas/launchql_public/tables/organization_profiles/constraints/organization_profiles_organization_id_key to pg
-- made with <3 @ launchql.com

-- requires: schemas/launchql_public/schema
-- requires: schemas/launchql_public/tables/organization_profiles/table
-- requires: schemas/launchql_public/tables/organization_profiles/indexes/organization_profiles_organization_id_idx

BEGIN;

ALTER TABLE "launchql_public".organization_profiles
    ADD CONSTRAINT organization_profiles_organization_id_key UNIQUE (organization_id);
COMMIT;
