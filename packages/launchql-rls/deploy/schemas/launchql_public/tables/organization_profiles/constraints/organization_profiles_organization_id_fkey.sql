-- Deploy: schemas/launchql_public/tables/organization_profiles/constraints/organization_profiles_organization_id_fkey to pg
-- made with <3 @ launchql.com

-- requires: schemas/launchql_public/schema
-- requires: schemas/launchql_public/tables/users/table
-- requires: schemas/launchql_public/tables/users/columns/id/column
-- requires: schemas/launchql_public/tables/organization_profiles/table
-- requires: schemas/launchql_public/tables/organization_profiles/columns/organization_id/column
-- requires: schemas/launchql_public/tables/organization_profiles/columns/organization_id/alterations/alt0000000074

BEGIN;

ALTER TABLE "launchql_public".organization_profiles 
    ADD CONSTRAINT organization_profiles_organization_id_fkey 
    FOREIGN KEY (organization_id)
    REFERENCES "launchql_public".users (id)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION;
COMMIT;
