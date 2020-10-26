-- Revert: schemas/launchql_public/tables/user_connections/columns/responder_id/column from pg

BEGIN;


ALTER TABLE "launchql_rls_public".user_connections DROP COLUMN responder_id;
COMMIT;  

