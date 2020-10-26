-- Deploy: schemas/launchql_public/tables/organization_profiles/columns/organization_id/column to pg
-- made with <3 @ launchql.com

-- requires: schemas/launchql_public/schema
-- requires: schemas/launchql_public/tables/organization_profiles/table
-- requires: schemas/launchql_public/tables/organization_profiles/triggers/tg_timestamps

BEGIN;

ALTER TABLE "launchql_public".organization_profiles ADD COLUMN organization_id uuid;
COMMIT;
