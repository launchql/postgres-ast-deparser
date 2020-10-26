-- Revert: schemas/launchql_public/tables/user_connections/columns/requester_id/column from pg

BEGIN;


ALTER TABLE "launchql_rls_public".user_connections DROP COLUMN requester_id;
COMMIT;  

