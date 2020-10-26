-- Revert: schemas/launchql_public/tables/organization_profiles/columns/reputation/column from pg

BEGIN;


ALTER TABLE "launchql_rls_public".organization_profiles DROP COLUMN reputation;
COMMIT;  

