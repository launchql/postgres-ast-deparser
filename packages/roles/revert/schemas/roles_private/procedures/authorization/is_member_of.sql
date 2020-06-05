-- Revert schemas/roles_private/procedures/authorization/is_member_of from pg

BEGIN;

DROP FUNCTION roles_private.is_member_of;

COMMIT;
