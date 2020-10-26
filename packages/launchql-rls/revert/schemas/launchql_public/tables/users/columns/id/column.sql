-- Revert: schemas/launchql_public/tables/users/columns/id/column from pg

BEGIN;


ALTER TABLE "launchql_rls_public".users DROP COLUMN id;
COMMIT;  

