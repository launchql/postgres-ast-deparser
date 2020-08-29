-- Revert schemas/roles_private/triggers/tg_immutable_role_properties from pg

BEGIN;

DROP FUNCTION roles_private.tg_immutable_role_properties;

COMMIT;
