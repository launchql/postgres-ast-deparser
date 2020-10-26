-- Revert: schemas/launchql_public/tables/user_profiles/columns/user_id/column from pg

BEGIN;


ALTER TABLE "launchql_rls_public".user_profiles DROP COLUMN user_id;
COMMIT;  

