-- Verify schemas/collaboration_private/procedures/collaboration_actor_role_admin_owner_authorized_profiles  on pg

BEGIN;

SELECT verify_function ('collaboration_private.collaboration_actor_role_admin_owner_authorized_profiles');

ROLLBACK;
