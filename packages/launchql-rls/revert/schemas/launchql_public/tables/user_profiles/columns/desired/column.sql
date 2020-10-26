-- Revert: schemas/launchql_public/tables/user_profiles/columns/desired/column from pg

BEGIN;


ALTER TABLE "launchql_rls_public".user_profiles DROP COLUMN desired;
COMMIT;  

