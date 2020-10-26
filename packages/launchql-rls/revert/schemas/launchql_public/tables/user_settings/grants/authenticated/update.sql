-- Revert: schemas/launchql_public/tables/user_settings/grants/authenticated/update from pg

BEGIN;
REVOKE UPDATE ON TABLE "launchql_rls_public".user_settings FROM authenticated;
COMMIT;  

