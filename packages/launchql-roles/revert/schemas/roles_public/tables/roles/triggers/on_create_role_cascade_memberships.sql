-- Revert schemas/roles_public/tables/roles/triggers/on_create_role_cascade_memberships from pg

BEGIN;

DROP TRIGGER on_create_role_cascade_memberships ON roles_public.roles;
DROP FUNCTION roles_private.tg_on_create_role_cascade_memberships; 

COMMIT;
