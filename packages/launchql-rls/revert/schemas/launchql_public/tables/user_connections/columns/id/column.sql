-- Revert: schemas/launchql_public/tables/user_connections/columns/id/column from pg

BEGIN;


ALTER TABLE "launchql_rls_public".user_connections DROP COLUMN id;
COMMIT;  

