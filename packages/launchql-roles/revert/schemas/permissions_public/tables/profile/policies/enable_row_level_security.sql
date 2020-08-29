-- Revert schemas/permissions_public/tables/profile/policies/enable_row_level_security from pg

BEGIN;

ALTER TABLE permissions_public.profile
    DISABLE ROW LEVEL SECURITY;

COMMIT;
