-- Revert: schemas/launchql_public/tables/user_characteristics/constraints/user_characteristics_user_id_fkey from pg

BEGIN;


ALTER TABLE "launchql_rls_public".user_characteristics 
    DROP CONSTRAINT user_characteristics_user_id_fkey;

COMMIT;  

