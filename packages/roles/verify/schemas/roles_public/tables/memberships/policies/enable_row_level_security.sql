-- Verify schemas/roles_public/tables/memberships/policies/enable_row_level_security  on pg

BEGIN;

SELECT verify_security ('roles_public.memberships');

ROLLBACK;
