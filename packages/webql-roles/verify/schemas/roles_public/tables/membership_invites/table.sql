-- Verify schemas/roles_public/tables/membership_invites/table on pg

BEGIN;

SELECT verify_table ('roles_public.membership_invites');

ROLLBACK;
