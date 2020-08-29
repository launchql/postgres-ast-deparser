-- Revert schemas/projects_public/tables/project/policies/project_policy from pg

BEGIN;


REVOKE INSERT ON TABLE projects_public.project FROM authenticated;
REVOKE SELECT ON TABLE projects_public.project FROM authenticated;
REVOKE UPDATE ON TABLE projects_public.project FROM authenticated;
REVOKE DELETE ON TABLE projects_public.project FROM authenticated;

DROP POLICY can_select_project ON projects_public.project;
DROP POLICY can_insert_project ON projects_public.project;
DROP POLICY can_update_project ON projects_public.project;
DROP POLICY can_delete_project ON projects_public.project;

COMMIT;
