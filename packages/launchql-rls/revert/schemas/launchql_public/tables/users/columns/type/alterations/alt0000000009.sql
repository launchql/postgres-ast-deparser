-- Revert: schemas/launchql_public/tables/users/columns/type/alterations/alt0000000009 from pg

BEGIN;


ALTER TABLE "launchql_rls_public".users 
    ALTER COLUMN type DROP DEFAULT;

COMMIT;  

