-- Revert: schemas/launchql_public/tables/user_connections/columns/accepted/column from pg

BEGIN;


ALTER TABLE "launchql_rls_public".user_connections DROP COLUMN accepted;
COMMIT;  

