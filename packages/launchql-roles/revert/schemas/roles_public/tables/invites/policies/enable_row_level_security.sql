-- Revert schemas/roles_public/tables/invites/policies/enable_row_level_security from pg

BEGIN;

ALTER TABLE roles_public.invites
    DISABLE ROW LEVEL SECURITY;

COMMIT;
