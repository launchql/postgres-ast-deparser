-- Revert schemas/roles_private/procedures/membership_cascade_hierarchy from pg

BEGIN;

DROP FUNCTION roles_private.membership_cascade_hierarchy;

COMMIT;
