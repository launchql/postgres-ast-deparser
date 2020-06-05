-- Revert schemas/roles_private/procedures/authorization/is_admin_of from pg

BEGIN;

DROP FUNCTION roles_private.is_admin_of;

COMMIT;
