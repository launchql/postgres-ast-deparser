-- Verify schemas/collections_public/tables/constraint/policies/project_constraint_policy  on pg

BEGIN;

SELECT verify_policy ('can_select_constraint', 'collections_public.constraint');
SELECT verify_policy ('can_insert_constraint', 'collections_public.constraint');
SELECT verify_policy ('can_update_constraint', 'collections_public.constraint');
SELECT verify_policy ('can_delete_constraint', 'collections_public.constraint');

SELECT verify_function ('collections_private.constraint_policy_fn');


SELECT has_table_privilege('authenticated', 'collections_public.constraint', 'INSERT');
SELECT has_table_privilege('authenticated', 'collections_public.constraint', 'SELECT');
SELECT has_table_privilege('authenticated', 'collections_public.constraint', 'UPDATE');
SELECT has_table_privilege('authenticated', 'collections_public.constraint', 'DELETE');

ROLLBACK;
