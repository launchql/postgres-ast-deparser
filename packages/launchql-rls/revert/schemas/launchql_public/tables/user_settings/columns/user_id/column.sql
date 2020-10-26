-- Revert: schemas/launchql_public/tables/user_settings/columns/user_id/column from pg

BEGIN;


ALTER TABLE "launchql_rls_public".user_settings DROP COLUMN user_id;
COMMIT;  

