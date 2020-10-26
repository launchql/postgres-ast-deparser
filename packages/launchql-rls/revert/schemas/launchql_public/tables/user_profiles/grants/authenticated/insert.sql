-- Revert: schemas/launchql_public/tables/user_profiles/grants/authenticated/insert from pg

BEGIN;
REVOKE INSERT ON TABLE "launchql_rls_public".user_profiles FROM authenticated;
COMMIT;  

