-- Revert: schemas/launchql_public/tables/users/columns/type/column from pg

BEGIN;


ALTER TABLE "launchql_rls_public".users DROP COLUMN type;
COMMIT;  

