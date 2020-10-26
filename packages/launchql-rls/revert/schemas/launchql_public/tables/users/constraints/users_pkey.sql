-- Revert: schemas/launchql_public/tables/users/constraints/users_pkey from pg

BEGIN;


ALTER TABLE "launchql_rls_public".users 
    DROP CONSTRAINT users_pkey;

COMMIT;  

