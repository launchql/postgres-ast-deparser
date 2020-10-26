-- Revert: schemas/launchql_public/tables/user_profiles/columns/bio/column from pg

BEGIN;


ALTER TABLE "launchql_rls_public".user_profiles DROP COLUMN bio;
COMMIT;  

