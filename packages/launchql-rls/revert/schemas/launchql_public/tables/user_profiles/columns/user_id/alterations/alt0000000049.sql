-- Revert: schemas/launchql_public/tables/user_profiles/columns/user_id/alterations/alt0000000049 from pg

BEGIN;


ALTER TABLE "launchql_rls_public".user_profiles 
    ALTER COLUMN user_id DROP NOT NULL;


COMMIT;  

