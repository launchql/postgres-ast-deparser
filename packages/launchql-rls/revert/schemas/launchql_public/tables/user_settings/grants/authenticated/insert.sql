-- Revert: schemas/launchql_public/tables/user_settings/grants/authenticated/insert from pg

BEGIN;
REVOKE INSERT ON TABLE "launchql_rls_public".user_settings FROM authenticated;
COMMIT;  

