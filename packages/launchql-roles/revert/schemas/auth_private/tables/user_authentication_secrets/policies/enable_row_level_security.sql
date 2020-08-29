-- Revert schemas/auth_private/tables/user_authentication_secrets/policies/enable_row_level_security from pg

BEGIN;

ALTER TABLE auth_private.user_authentication_secrets
    DISABLE ROW LEVEL SECURITY;

COMMIT;
