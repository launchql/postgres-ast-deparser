-- Revert: schemas/launchql_public/tables/user_connections/table from pg

BEGIN;
DROP TABLE "launchql_rls_public".user_connections;
COMMIT;  

