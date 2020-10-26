-- Revert: schemas/launchql_public/tables/user_profiles/grants/authenticated/delete from pg

BEGIN;
REVOKE DELETE ON TABLE "launchql_rls_public".user_profiles FROM authenticated;
COMMIT;  

