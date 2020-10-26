-- Revert: schemas/launchql_public/tables/organization_profiles/columns/organization_id/alterations/alt0000000074 from pg

BEGIN;


ALTER TABLE "launchql_rls_public".organization_profiles 
    ALTER COLUMN organization_id DROP NOT NULL;


COMMIT;  

