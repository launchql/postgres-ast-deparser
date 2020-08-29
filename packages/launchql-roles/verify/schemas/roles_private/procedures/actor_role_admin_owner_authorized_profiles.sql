-- Verify schemas/roles_private/procedures/actor_role_admin_owner_authorized_profiles  on pg

BEGIN;

SELECT verify_function ('roles_private.actor_role_admin_owner_authorized_profiles');

ROLLBACK;
