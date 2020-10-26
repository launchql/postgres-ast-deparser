-- Revert: schemas/launchql_public/tables/user_settings/grants/authenticated/select from pg

BEGIN;
REVOKE SELECT ON TABLE "launchql_rls_public".user_settings FROM authenticated;
COMMIT;  

