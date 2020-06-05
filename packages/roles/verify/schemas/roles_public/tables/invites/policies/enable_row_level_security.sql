-- Verify schemas/roles_public/tables/invites/policies/enable_row_level_security  on pg

BEGIN;

SELECT verify_security ('roles_public.invites');

ROLLBACK;
