-- Deploy: schemas/launchql_public/tables/organization_profiles/columns/organization_id/alterations/alt0000000074 to pg
-- made with <3 @ launchql.com

-- requires: schemas/launchql_public/schema
-- requires: schemas/launchql_public/tables/organization_profiles/table
-- requires: schemas/launchql_public/tables/organization_profiles/columns/organization_id/column

BEGIN;

ALTER TABLE "launchql_public".organization_profiles 
    ALTER COLUMN organization_id SET NOT NULL;
COMMIT;
