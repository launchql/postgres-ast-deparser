-- Revert: schemas/launchql_public/tables/organization_profiles/table from pg

BEGIN;
DROP TABLE "launchql_rls_public".organization_profiles;
COMMIT;  

