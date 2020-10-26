-- Deploy: schemas/launchql_public/tables/organization_profiles/columns/reputation/alterations/alt0000000073 to pg
-- made with <3 @ launchql.com

-- requires: schemas/launchql_public/schema
-- requires: schemas/launchql_public/tables/organization_profiles/table
-- requires: schemas/launchql_public/tables/organization_profiles/columns/reputation/column

BEGIN;

ALTER TABLE "launchql_public".organization_profiles 
    ALTER COLUMN reputation SET DEFAULT 0;
COMMIT;
