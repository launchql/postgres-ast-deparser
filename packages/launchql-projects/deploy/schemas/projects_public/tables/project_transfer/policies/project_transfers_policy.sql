-- Deploy schemas/projects_public/tables/project_transfer/policies/project_transfers_policy to pg
-- requires: schemas/projects_public/schema
-- requires: schemas/projects_public/tables/project_transfer/table
-- requires: schemas/projects_public/tables/project_transfer/policies/enable_row_level_security
-- requires: schemas/collaboration_private/procedures/permitted_on_project

BEGIN;
CREATE POLICY can_select_project_transfers ON projects_public.project_transfer
  FOR SELECT
    USING (((roles_public.current_role_id () = sender_id)
    OR permissions_private.permitted_on_role ('transfer', 'project', current_owner_id)
    OR collaboration_private.permitted_on_project ('transfer', 'project', project_id)
    OR permissions_private.permitted_on_role ('transfer', 'project', new_owner_id))
    AND EXTRACT(EPOCH FROM (expires_at - NOW())) > 0);
CREATE POLICY can_insert_project_transfers ON projects_public.project_transfer
  FOR INSERT
    WITH CHECK (permissions_private.permitted_on_role ('transfer', 'project', current_owner_id)
    OR collaboration_private.permitted_on_project ('transfer', 'project', project_id));
CREATE POLICY can_update_project_transfers ON projects_public.project_transfer
  FOR UPDATE
    USING (permissions_private.permitted_on_role ('transfer', 'project', new_owner_id)
    AND EXTRACT(EPOCH FROM (expires_at - NOW())) > 0);
CREATE POLICY can_delete_project_transfers ON projects_public.project_transfer
  FOR DELETE
    USING (EXTRACT(EPOCH FROM (expires_at - NOW())) > 0
      AND NOT transferred
      AND (permissions_private.permitted_on_role ('transfer', 'project', current_owner_id)
        OR collaboration_private.permitted_on_project ('transfer', 'project', project_id)
        OR permissions_private.permitted_on_role ('transfer', 'project', new_owner_id)
      ));
GRANT INSERT (project_id, new_owner_id) ON TABLE projects_public.project_transfer TO authenticated;
GRANT SELECT (id, project_id, current_owner_id, new_owner_id, accepted, transferred, sender_id, expires_at, created_at) ON TABLE projects_public.project_transfer TO authenticated;
GRANT UPDATE (accepted) ON TABLE projects_public.project_transfer TO authenticated;
GRANT DELETE ON TABLE projects_public.project_transfer TO authenticated;
COMMIT;

