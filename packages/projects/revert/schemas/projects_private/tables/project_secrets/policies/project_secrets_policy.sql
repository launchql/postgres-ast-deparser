-- Revert schemas/projects_private/tables/project_secrets/policies/project_secrets_policy from pg

BEGIN;


REVOKE INSERT ON TABLE projects_private.project_secrets FROM authenticated;
REVOKE SELECT ON TABLE projects_private.project_secrets FROM authenticated;
REVOKE UPDATE ON TABLE projects_private.project_secrets FROM authenticated;
REVOKE DELETE ON TABLE projects_private.project_secrets FROM authenticated;


DROP POLICY can_select_project_secrets ON projects_private.project_secrets;
DROP POLICY can_insert_project_secrets ON projects_private.project_secrets;
DROP POLICY can_update_project_secrets ON projects_private.project_secrets;
DROP POLICY can_delete_project_secrets ON projects_private.project_secrets;

COMMIT;
