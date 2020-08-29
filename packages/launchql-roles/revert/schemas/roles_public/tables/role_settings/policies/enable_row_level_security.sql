-- Revert schemas/roles_public/tables/role_settings/policies/enable_row_level_security from pg

BEGIN;

ALTER TABLE roles_public.role_settings
    DISABLE ROW LEVEL SECURITY;

COMMIT;
