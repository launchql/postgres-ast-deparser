-- Revert schemas/roles_public/tables/membership_invites/policies/enable_row_level_security from pg

BEGIN;

ALTER TABLE roles_public.membership_invites
    DISABLE ROW LEVEL SECURITY;

COMMIT;
