-- Revert schemas/projects_public/tables/project_transfer/policies/project_transfers_policy from pg

BEGIN;


REVOKE INSERT ON TABLE projects_public.project_transfers FROM authenticated;
REVOKE SELECT ON TABLE projects_public.project_transfers FROM authenticated;
REVOKE UPDATE ON TABLE projects_public.project_transfers FROM authenticated;
REVOKE DELETE ON TABLE projects_public.project_transfers FROM authenticated;

DROP POLICY can_select_project_transfers ON projects_public.project_transfers;
DROP POLICY can_insert_project_transfers ON projects_public.project_transfers;
DROP POLICY can_update_project_transfers ON projects_public.project_transfers;
DROP POLICY can_delete_project_transfers ON projects_public.project_transfers;

COMMIT;
