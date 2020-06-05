-- Revert schemas/roles_private/procedures/actor_role_admin_owner_authorized_profiles from pg

BEGIN;

DROP FUNCTION roles_private.actor_role_admin_owner_authorized_profiles;

COMMIT;
