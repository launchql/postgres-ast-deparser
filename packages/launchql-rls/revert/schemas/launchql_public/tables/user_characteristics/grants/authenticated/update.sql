-- Revert: schemas/launchql_public/tables/user_characteristics/grants/authenticated/update from pg

BEGIN;
REVOKE UPDATE ON TABLE "launchql_rls_public".user_characteristics FROM authenticated;
COMMIT;  

