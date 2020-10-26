-- Revert: schemas/launchql_public/tables/user_profiles/table from pg

BEGIN;
DROP TABLE "launchql_rls_public".user_profiles;
COMMIT;  

