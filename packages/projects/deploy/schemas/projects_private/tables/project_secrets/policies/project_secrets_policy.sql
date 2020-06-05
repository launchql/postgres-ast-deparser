-- Deploy schemas/projects_private/tables/project_secrets/policies/project_secrets_policy to pg
-- requires: schemas/projects_private/schema
-- requires: schemas/projects_private/tables/project_secrets/table
-- requires: schemas/projects_private/tables/project_secrets/policies/enable_row_level_security
-- requires: schemas/projects_public/tables/project/table

BEGIN;
CREATE POLICY can_select_project_secrets ON projects_private.project_secrets
  FOR SELECT
    USING (collaboration_private.permitted_on_project ('read', 'secret', project_id));
CREATE POLICY can_insert_project_secrets ON projects_private.project_secrets
  FOR INSERT
    WITH CHECK (collaboration_private.permitted_on_project ('add', 'secret', project_id));
CREATE POLICY can_update_project_secrets ON projects_private.project_secrets
  FOR UPDATE
    USING (collaboration_private.permitted_on_project ('edit', 'secret', project_id));
CREATE POLICY can_delete_project_secrets ON projects_private.project_secrets
  FOR DELETE
    USING (collaboration_private.permitted_on_project ('destroy', 'secret', project_id));
GRANT INSERT ON TABLE projects_private.project_secrets TO authenticated;
GRANT SELECT ON TABLE projects_private.project_secrets TO authenticated;
GRANT UPDATE ON TABLE projects_private.project_secrets TO authenticated;
GRANT DELETE ON TABLE projects_private.project_secrets TO authenticated;
COMMIT;

