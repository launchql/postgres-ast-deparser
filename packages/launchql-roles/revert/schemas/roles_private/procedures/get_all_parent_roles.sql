-- Revert schemas/roles_private/procedures/get_all_parent_roles from pg

BEGIN;

DROP FUNCTION roles_private.get_all_parent_roles;

COMMIT;
