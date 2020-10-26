-- Deploy: schemas/launchql_public/tables/organization_profiles/alterations/alt0000000070 to pg
-- made with <3 @ launchql.com

-- requires: schemas/launchql_public/schema
-- requires: schemas/launchql_public/tables/organization_profiles/table

BEGIN;

ALTER TABLE "launchql_public".organization_profiles
    DISABLE ROW LEVEL SECURITY;
COMMIT;
