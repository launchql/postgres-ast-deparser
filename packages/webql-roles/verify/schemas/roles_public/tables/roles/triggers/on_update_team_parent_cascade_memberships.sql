-- Verify schemas/roles_public/tables/roles/triggers/on_update_team_parent_cascade_memberships  on pg

BEGIN;

SELECT verify_function ('roles_private.tg_on_update_team_parent_cascade_memberships'); 
SELECT verify_trigger ('roles_public.on_update_team_parent_cascade_memberships');

ROLLBACK;
