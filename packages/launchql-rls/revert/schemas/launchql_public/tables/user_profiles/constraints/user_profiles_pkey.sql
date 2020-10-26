-- Revert: schemas/launchql_public/tables/user_profiles/constraints/user_profiles_pkey from pg

BEGIN;


ALTER TABLE "launchql_rls_public".user_profiles 
    DROP CONSTRAINT user_profiles_pkey;

COMMIT;  

