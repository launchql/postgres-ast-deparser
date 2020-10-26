-- Revert: schemas/launchql_public/tables/user_settings/grants/authenticated/delete from pg

BEGIN;
REVOKE DELETE ON TABLE "launchql_rls_public".user_settings FROM authenticated;
COMMIT;  

