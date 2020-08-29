-- Verify schemas/roles_public/tables/membership_invites/policies/enable_row_level_security  on pg

BEGIN;

SELECT verify_security ('roles_public.membership_invites');

ROLLBACK;
