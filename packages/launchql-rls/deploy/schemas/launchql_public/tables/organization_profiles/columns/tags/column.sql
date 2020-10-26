-- Deploy: schemas/launchql_public/tables/organization_profiles/columns/tags/column to pg
-- made with <3 @ launchql.com

-- requires: schemas/launchql_public/schema
-- requires: schemas/launchql_public/tables/organization_profiles/table
-- requires: schemas/launchql_public/tables/organization_profiles/columns/reputation/alterations/alt0000000073

BEGIN;

ALTER TABLE "launchql_public".organization_profiles ADD COLUMN tags citext[];
COMMIT;
