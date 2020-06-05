-- Revert schemas/roles_private/tables/user_email_secrets/policies/enable_row_level_security from pg

BEGIN;

ALTER TABLE roles_private.user_email_secrets
    DISABLE ROW LEVEL SECURITY;

COMMIT;
