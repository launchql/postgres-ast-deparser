-- Deploy schemas/projects_public/tables/project/policies/project_policy to pg
-- requires: schemas/projects_public/schema
-- requires: schemas/projects_public/tables/project/table
-- requires: schemas/projects_public/tables/project/policies/enable_row_level_security
-- requires: schemas/collaboration_private/procedures/permitted_on_project

-- NOTES: some of the permitted_on_role are for individuals... should we just those into the permits?

BEGIN;
CREATE POLICY can_select_project ON projects_public.project
  FOR SELECT
    USING (permissions_private.permitted_on_role ('browse', 'project', owner_id)
    OR collaboration_private.permitted_on_project ('browse', 'project', id));
CREATE POLICY can_insert_project ON projects_public.project
  FOR INSERT
    WITH CHECK (permissions_private.permitted_on_role ('add', 'project', owner_id));
CREATE POLICY can_update_project ON projects_public.project
  FOR UPDATE
    USING (permissions_private.permitted_on_role ('edit', 'project', owner_id)
    OR collaboration_private.permitted_on_project ('edit', 'project', id));
CREATE POLICY can_delete_project ON projects_public.project
  FOR DELETE
    USING (permissions_private.permitted_on_role ('destroy', 'project', owner_id)
    OR collaboration_private.permitted_on_project ('destroy', 'project', id));
GRANT INSERT ON TABLE projects_public.project TO authenticated;
GRANT SELECT ON TABLE projects_public.project TO authenticated;
GRANT UPDATE ON TABLE projects_public.project TO authenticated;
GRANT DELETE ON TABLE projects_public.project TO authenticated;
COMMIT;

