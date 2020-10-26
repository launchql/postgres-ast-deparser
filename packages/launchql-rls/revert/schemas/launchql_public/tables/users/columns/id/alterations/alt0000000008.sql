-- Revert: schemas/launchql_public/tables/users/columns/id/alterations/alt0000000008 from pg

BEGIN;


ALTER TABLE "launchql_rls_public".users 
    ALTER COLUMN id DROP DEFAULT;

COMMIT;  

