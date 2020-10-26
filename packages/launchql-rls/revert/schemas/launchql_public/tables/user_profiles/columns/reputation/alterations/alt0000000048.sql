-- Revert: schemas/launchql_public/tables/user_profiles/columns/reputation/alterations/alt0000000048 from pg

BEGIN;


ALTER TABLE "launchql_rls_public".user_profiles 
    ALTER COLUMN reputation DROP DEFAULT;

COMMIT;  

