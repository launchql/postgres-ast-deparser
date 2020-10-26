-- Deploy: schemas/launchql_public/tables/organization_profiles/constraints/organization_profiles_pkey to pg
-- made with <3 @ launchql.com

-- requires: schemas/launchql_public/schema
-- requires: schemas/launchql_public/tables/organization_profiles/table
-- requires: schemas/launchql_public/tables/organization_profiles/columns/id/alterations/alt0000000072

BEGIN;

ALTER TABLE "launchql_public".organization_profiles
    ADD CONSTRAINT organization_profiles_pkey PRIMARY KEY (id);
COMMIT;
