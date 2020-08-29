-- Revert schemas/roles_private/procedures/registration/link_or_register_user from pg

BEGIN;

DROP FUNCTION roles_private.link_or_register_user;

COMMIT;
