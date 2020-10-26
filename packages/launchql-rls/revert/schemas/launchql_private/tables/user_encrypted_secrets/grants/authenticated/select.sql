-- Revert: schemas/launchql_private/tables/user_encrypted_secrets/grants/authenticated/select from pg

BEGIN;
REVOKE SELECT ON TABLE "launchql_rls_private".user_encrypted_secrets FROM authenticated;
COMMIT;  

