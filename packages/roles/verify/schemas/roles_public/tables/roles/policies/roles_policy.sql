-- Verify schemas/roles_public/tables/roles/policies/roles_policy  on pg

BEGIN;

SELECT verify_policy ('can_select_roles', 'roles_public.roles');
SELECT verify_policy ('can_insert_roles', 'roles_public.roles');
SELECT verify_policy ('can_update_roles', 'roles_public.roles');
SELECT verify_policy ('can_delete_roles', 'roles_public.roles');

SELECT has_table_privilege('authenticated', 'roles_public.roles', 'INSERT');
SELECT has_table_privilege('authenticated', 'roles_public.roles', 'SELECT');
SELECT has_table_privilege('authenticated', 'roles_public.roles', 'UPDATE');
SELECT has_table_privilege('authenticated', 'roles_public.roles', 'DELETE');

ROLLBACK;
