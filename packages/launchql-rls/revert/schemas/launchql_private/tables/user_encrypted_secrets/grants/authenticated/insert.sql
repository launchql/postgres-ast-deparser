-- Revert: schemas/launchql_private/tables/user_encrypted_secrets/grants/authenticated/insert from pg

BEGIN;
REVOKE INSERT ON TABLE "launchql_rls_private".user_encrypted_secrets FROM authenticated;
COMMIT;  

