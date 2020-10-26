-- Revert: schemas/launchql_private/tables/user_secrets/grants/authenticated/insert from pg

BEGIN;
REVOKE INSERT ON TABLE "launchql_rls_private".user_secrets FROM authenticated;
COMMIT;  

