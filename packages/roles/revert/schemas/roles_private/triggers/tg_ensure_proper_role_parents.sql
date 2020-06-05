-- Revert schemas/roles_private/triggers/tg_ensure_proper_role_parents from pg

BEGIN;

DROP FUNCTION roles_private.tg_ensure_proper_role_parents;

COMMIT;
