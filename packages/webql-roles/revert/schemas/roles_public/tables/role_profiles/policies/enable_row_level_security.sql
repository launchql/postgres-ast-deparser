-- Revert schemas/roles_public/tables/role_profiles/policies/enable_row_level_security from pg

BEGIN;

ALTER TABLE roles_public.role_profiles
    DISABLE ROW LEVEL SECURITY;

COMMIT;
