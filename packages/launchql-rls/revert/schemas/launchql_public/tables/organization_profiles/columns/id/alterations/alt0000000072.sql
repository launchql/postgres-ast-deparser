-- Revert: schemas/launchql_public/tables/organization_profiles/columns/id/alterations/alt0000000072 from pg

BEGIN;


ALTER TABLE "launchql_rls_public".organization_profiles 
    ALTER COLUMN id DROP DEFAULT;

COMMIT;  

