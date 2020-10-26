-- Deploy: schemas/launchql_public/tables/organization_profiles/columns/id/alterations/alt0000000072 to pg
-- made with <3 @ launchql.com

-- requires: schemas/launchql_public/schema
-- requires: schemas/launchql_public/tables/organization_profiles/table
-- requires: schemas/launchql_public/tables/organization_profiles/columns/id/column
-- requires: schemas/launchql_public/tables/organization_profiles/columns/id/alterations/alt0000000071

BEGIN;

ALTER TABLE "launchql_public".organization_profiles 
    ALTER COLUMN id SET DEFAULT "launchql_private".uuid_generate_v4();
COMMIT;
