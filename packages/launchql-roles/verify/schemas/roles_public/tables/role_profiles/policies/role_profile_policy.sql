-- Verify schemas/roles_public/tables/role_profiles/policies/role_profile_policy  on pg

BEGIN;

SELECT verify_policy ('can_select_role_profiles', 'roles_public.role_profiles');
SELECT verify_policy ('can_insert_role_profiles', 'roles_public.role_profiles');
SELECT verify_policy ('can_update_role_profiles', 'roles_public.role_profiles');

SELECT has_table_privilege('authenticated', 'roles_public.role_profiles', 'INSERT');
SELECT has_table_privilege('authenticated', 'roles_public.role_profiles', 'SELECT');
SELECT has_table_privilege('authenticated', 'roles_public.role_profiles', 'UPDATE');

ROLLBACK;
