-- Verify schemas/roles_private/procedures/team_cascade_memberships  on pg

BEGIN;

SELECT verify_function ('roles_private.role_cascade_memberships');

ROLLBACK;
