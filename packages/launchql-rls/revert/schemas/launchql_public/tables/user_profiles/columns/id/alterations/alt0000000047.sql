-- Revert: schemas/launchql_public/tables/user_profiles/columns/id/alterations/alt0000000047 from pg

BEGIN;


ALTER TABLE "launchql_rls_public".user_profiles 
    ALTER COLUMN id DROP DEFAULT;

COMMIT;  

