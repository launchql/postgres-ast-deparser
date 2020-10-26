-- Revert: schemas/launchql_public/tables/organization_profiles/constraints/organization_profiles_pkey from pg

BEGIN;


ALTER TABLE "launchql_rls_public".organization_profiles 
    DROP CONSTRAINT organization_profiles_pkey;

COMMIT;  

