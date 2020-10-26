-- Revert: schemas/launchql_public/tables/users/table from pg

BEGIN;
DROP TABLE "launchql_rls_public".users;
COMMIT;  

