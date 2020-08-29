-- Revert schemas/permissions_private/procedures/permitted_on_role from pg

BEGIN;

DROP FUNCTION permissions_private.permitted_on_role;

COMMIT;
