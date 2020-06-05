-- Verify schemas/roles_public/tables/memberships/policies/membership_policy  on pg

BEGIN;

SELECT verify_policy ('can_select_membership', 'roles_public.memberships');
SELECT verify_policy ('can_insert_membership', 'roles_public.memberships');
SELECT verify_policy ('can_update_membership', 'roles_public.memberships');
SELECT verify_policy ('can_delete_membership', 'roles_public.memberships');

SELECT has_table_privilege('authenticated', 'roles_public.memberships', 'SELECT');
SELECT has_table_privilege('authenticated', 'roles_public.memberships', 'INSERT');
SELECT has_table_privilege('authenticated', 'roles_public.memberships', 'UPDATE');
SELECT has_table_privilege('authenticated', 'roles_public.memberships', 'DELETE');

ROLLBACK;
