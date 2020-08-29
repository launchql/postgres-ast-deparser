-- Revert schemas/roles_private/procedures/validate_role_parent from pg

BEGIN;

DROP FUNCTION roles_private.validate_role_parent;

COMMIT;
