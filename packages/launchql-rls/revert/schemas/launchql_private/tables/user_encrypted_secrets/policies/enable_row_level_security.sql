-- Revert: schemas/launchql_private/tables/user_encrypted_secrets/policies/enable_row_level_security from pg

BEGIN;


ALTER TABLE "launchql_rls_private".user_encrypted_secrets
    DISABLE ROW LEVEL SECURITY;

COMMIT;  

