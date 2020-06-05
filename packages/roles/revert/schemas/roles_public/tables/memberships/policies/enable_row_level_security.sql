-- Revert schemas/roles_public/tables/memberships/policies/enable_row_level_security from pg

BEGIN;

ALTER TABLE roles_public.memberships
    DISABLE ROW LEVEL SECURITY;

COMMIT;
