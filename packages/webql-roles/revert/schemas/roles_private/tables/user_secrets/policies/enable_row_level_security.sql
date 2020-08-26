-- Revert schemas/roles_private/tables/user_secrets/policies/enable_row_level_security from pg

BEGIN;

ALTER TABLE roles_private.user_secrets
    DISABLE ROW LEVEL SECURITY;

COMMIT;
