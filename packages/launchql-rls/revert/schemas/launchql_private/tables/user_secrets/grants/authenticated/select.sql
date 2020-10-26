-- Revert: schemas/launchql_private/tables/user_secrets/grants/authenticated/select from pg

BEGIN;
REVOKE SELECT ON TABLE "launchql_rls_private".user_secrets FROM authenticated;
COMMIT;  

