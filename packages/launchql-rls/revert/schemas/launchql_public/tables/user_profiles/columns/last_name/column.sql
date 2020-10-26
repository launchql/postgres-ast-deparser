-- Revert: schemas/launchql_public/tables/user_profiles/columns/last_name/column from pg

BEGIN;


ALTER TABLE "launchql_rls_public".user_profiles DROP COLUMN last_name;
COMMIT;  

