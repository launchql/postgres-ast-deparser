-- Revert: schemas/launchql_public/tables/user_profiles/grants/authenticated/select from pg

BEGIN;
REVOKE SELECT ON TABLE "launchql_rls_public".user_profiles FROM authenticated;
COMMIT;  

