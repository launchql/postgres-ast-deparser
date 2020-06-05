-- Verify schemas/roles_public/tables/role_settings/policies/role_settings_policy  on pg

BEGIN;

SELECT verify_policy ('can_select_role_settings', 'roles_public.role_settings');
SELECT verify_policy ('can_insert_role_settings', 'roles_public.role_settings');
SELECT verify_policy ('can_update_role_settings', 'roles_public.role_settings');

SELECT has_table_privilege('authenticated', 'roles_public.role_settings', 'INSERT');
SELECT has_table_privilege('authenticated', 'roles_public.role_settings', 'SELECT');
SELECT has_table_privilege('authenticated', 'roles_public.role_settings', 'UPDATE');

ROLLBACK;
