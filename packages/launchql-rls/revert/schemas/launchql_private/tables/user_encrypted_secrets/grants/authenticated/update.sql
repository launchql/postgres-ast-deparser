-- Revert: schemas/launchql_private/tables/user_encrypted_secrets/grants/authenticated/update from pg

BEGIN;
REVOKE UPDATE ON TABLE "launchql_rls_private".user_encrypted_secrets FROM authenticated;
COMMIT;  

