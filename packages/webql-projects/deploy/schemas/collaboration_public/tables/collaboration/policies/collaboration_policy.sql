-- Deploy schemas/collaboration_public/tables/collaboration/policies/collaboration_policy to pg
-- requires: schemas/collaboration_public/schema
-- requires: schemas/collaboration_public/tables/collaboration/table
-- requires: schemas/collaboration_public/tables/collaboration/policies/enable_row_level_security
-- requires: schemas/collaboration_private/procedures/permitted_on_project
-- requires: schemas/collaboration_private/procedures/collaboration_actor_role_admin_owner_authorized_profiles

BEGIN;
CREATE POLICY can_select_collaboration ON collaboration_public.collaboration
  FOR SELECT
    USING (collaboration_private.permitted_on_project ('read', 'user', project_id));
CREATE POLICY can_insert_collaboration ON collaboration_public.collaboration
  FOR INSERT
    WITH CHECK (collaboration_private.permitted_on_project ('add', 'user', project_id)
    AND collaboration_private.collaboration_actor_role_admin_owner_authorized_profiles (roles_public.current_role_id (), project_id, profile_id, organization_id));
CREATE POLICY can_update_collaboration ON collaboration_public.collaboration
  FOR UPDATE
    USING (collaboration_private.permitted_on_project ('edit', 'user', project_id)
    AND collaboration_private.collaboration_actor_role_admin_owner_authorized_profiles (roles_public.current_role_id (), project_id, profile_id, organization_id));
CREATE POLICY can_delete_collaboration ON collaboration_public.collaboration
  FOR DELETE
    USING (collaboration_private.permitted_on_project ('destroy', 'user', project_id)
    AND collaboration_private.collaboration_actor_role_admin_owner_authorized_profiles (roles_public.current_role_id (), project_id, profile_id, organization_id));
GRANT INSERT ON TABLE collaboration_public.collaboration TO authenticated;
GRANT SELECT ON TABLE collaboration_public.collaboration TO authenticated;
GRANT UPDATE ON TABLE collaboration_public.collaboration TO authenticated;
GRANT DELETE ON TABLE collaboration_public.collaboration TO authenticated;
COMMIT;

