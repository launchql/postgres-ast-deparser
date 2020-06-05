-- Revert schemas/projects_private/tables/project_grants/grants/grant_select_insert_update_delete_to_authenticated from pg

BEGIN;

REVOKE SELECT, INSERT, UPDATE, DELETE ON TABLE projects_private.project_grants FROM authenticated;

COMMIT;
