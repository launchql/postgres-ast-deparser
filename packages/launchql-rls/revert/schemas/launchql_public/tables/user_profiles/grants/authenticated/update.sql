-- Revert: schemas/launchql_public/tables/user_profiles/grants/authenticated/update from pg

BEGIN;
REVOKE UPDATE ON TABLE "launchql_rls_public".user_profiles FROM authenticated;
COMMIT;  

