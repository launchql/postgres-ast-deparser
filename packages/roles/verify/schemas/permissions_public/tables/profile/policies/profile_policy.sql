-- Verify schemas/permissions_public/tables/profile/policies/profile_policy  on pg

BEGIN;

SELECT verify_policy ('can_select_profile', 'permissions_public.profile');
SELECT verify_policy ('can_insert_profile', 'permissions_public.profile');
SELECT verify_policy ('can_update_profile', 'permissions_public.profile');
SELECT verify_policy ('can_delete_profile', 'permissions_public.profile');

SELECT verify_function ('permissions_private.profile_policy_fn');


SELECT has_table_privilege('authenticated', 'permissions_public.profile', 'INSERT');
SELECT has_table_privilege('authenticated', 'permissions_public.profile', 'SELECT');
SELECT has_table_privilege('authenticated', 'permissions_public.profile', 'UPDATE');
SELECT has_table_privilege('authenticated', 'permissions_public.profile', 'DELETE');

ROLLBACK;
