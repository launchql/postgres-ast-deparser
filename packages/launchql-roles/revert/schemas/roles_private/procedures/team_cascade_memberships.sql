-- Revert schemas/roles_private/procedures/team_cascade_memberships from pg

BEGIN;

DROP FUNCTION roles_private.role_cascade_memberships;

COMMIT;
