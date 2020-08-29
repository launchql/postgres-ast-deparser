-- Verify schemas/projects_private/tables/project_secrets/policies/project_secrets_policy  on pg

BEGIN;

SELECT verify_policy ('can_select_project_secrets', 'projects_private.project_secrets');
SELECT verify_policy ('can_insert_project_secrets', 'projects_private.project_secrets');
SELECT verify_policy ('can_update_project_secrets', 'projects_private.project_secrets');
SELECT verify_policy ('can_delete_project_secrets', 'projects_private.project_secrets');

SELECT has_table_privilege('authenticated', 'projects_private.project_secrets', 'INSERT');
SELECT has_table_privilege('authenticated', 'projects_private.project_secrets', 'SELECT');
SELECT has_table_privilege('authenticated', 'projects_private.project_secrets', 'UPDATE');
SELECT has_table_privilege('authenticated', 'projects_private.project_secrets', 'DELETE');

ROLLBACK;
