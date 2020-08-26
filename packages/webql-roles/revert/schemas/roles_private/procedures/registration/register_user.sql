-- Revert schemas/roles_private/procedures/registration/register_user from pg

BEGIN;

DROP FUNCTION roles_private.register_user;

COMMIT;
