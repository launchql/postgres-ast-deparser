-- Revert: schemas/launchql_public/tables/organization_profiles/columns/name/column from pg

BEGIN;


ALTER TABLE "launchql_rls_public".organization_profiles DROP COLUMN name;
COMMIT;  

