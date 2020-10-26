-- Revert: schemas/launchql_public/tables/user_profiles/columns/first_name/column from pg

BEGIN;


ALTER TABLE "launchql_rls_public".user_profiles DROP COLUMN first_name;
COMMIT;  

