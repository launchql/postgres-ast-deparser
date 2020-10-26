-- Revert: schemas/launchql_private/tables/user_encrypted_secrets/grants/authenticated/delete from pg

BEGIN;
REVOKE DELETE ON TABLE "launchql_rls_private".user_encrypted_secrets FROM authenticated;
COMMIT;  

