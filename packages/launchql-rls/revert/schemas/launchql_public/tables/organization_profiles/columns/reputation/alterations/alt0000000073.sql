-- Revert: schemas/launchql_public/tables/organization_profiles/columns/reputation/alterations/alt0000000073 from pg

BEGIN;


ALTER TABLE "launchql_rls_public".organization_profiles 
    ALTER COLUMN reputation DROP DEFAULT;

COMMIT;  

