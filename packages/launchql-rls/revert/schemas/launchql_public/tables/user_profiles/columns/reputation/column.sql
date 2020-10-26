-- Revert: schemas/launchql_public/tables/user_profiles/columns/reputation/column from pg

BEGIN;


ALTER TABLE "launchql_rls_public".user_profiles DROP COLUMN reputation;
COMMIT;  

