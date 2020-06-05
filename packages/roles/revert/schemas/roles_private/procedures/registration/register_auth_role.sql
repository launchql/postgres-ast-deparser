-- Revert schemas/roles_private/procedures/registration/register_auth_role from pg

BEGIN;

DROP FUNCTION roles_private.register_auth_role;

COMMIT;
