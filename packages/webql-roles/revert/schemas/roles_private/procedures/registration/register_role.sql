-- Revert schemas/roles_private/procedures/registration/register_role from pg

BEGIN;

DROP FUNCTION roles_private.register_role;

COMMIT;
