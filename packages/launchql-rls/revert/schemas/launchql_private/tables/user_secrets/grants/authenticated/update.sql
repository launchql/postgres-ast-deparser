-- Revert: schemas/launchql_private/tables/user_secrets/grants/authenticated/update from pg

BEGIN;
REVOKE UPDATE ON TABLE "launchql_rls_private".user_secrets FROM authenticated;
COMMIT;  

