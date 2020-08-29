-- Revert schemas/roles_private/procedures/authorization/is_owner_of from pg

BEGIN;

DROP FUNCTION roles_private.is_owner_of;

COMMIT;
