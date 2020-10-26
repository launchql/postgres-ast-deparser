-- Deploy: schemas/launchql_public/tables/organization_profiles/columns/name/column to pg
-- made with <3 @ launchql.com

-- requires: schemas/launchql_public/schema
-- requires: schemas/launchql_public/tables/organization_profiles/table
-- requires: schemas/launchql_public/tables/organization_profiles/constraints/organization_profiles_pkey

BEGIN;

ALTER TABLE "launchql_public".organization_profiles ADD COLUMN name text;
COMMIT;
