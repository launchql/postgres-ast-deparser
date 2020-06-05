-- Revert schemas/roles_public/tables/user_emails/policies/enable_row_level_security from pg

BEGIN;

ALTER TABLE roles_public.user_emails
    DISABLE ROW LEVEL SECURITY;

COMMIT;
