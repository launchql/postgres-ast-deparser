-- Revert schemas/roles_public/tables/roles/triggers/on_update_team_parent_cascade_memberships from pg

BEGIN;

DROP TRIGGER on_update_team_parent_cascade_memberships ON roles_public.roles;
DROP FUNCTION roles_private.tg_on_update_team_parent_cascade_memberships; 

COMMIT;
