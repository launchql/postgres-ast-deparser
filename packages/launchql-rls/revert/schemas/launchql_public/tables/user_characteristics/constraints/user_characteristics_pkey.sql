-- Revert: schemas/launchql_public/tables/user_characteristics/constraints/user_characteristics_pkey from pg

BEGIN;


ALTER TABLE "launchql_rls_public".user_characteristics 
    DROP CONSTRAINT user_characteristics_pkey;

COMMIT;  

