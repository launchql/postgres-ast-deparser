-- Verify schemas/collections_public/tables/unique_constraint/policies/project_unique_constraint_policy  on pg

BEGIN;

SELECT verify_policy ('can_select_unique_constraint', 'collections_public.unique_constraint');
SELECT verify_policy ('can_insert_unique_constraint', 'collections_public.unique_constraint');
SELECT verify_policy ('can_update_unique_constraint', 'collections_public.unique_constraint');
SELECT verify_policy ('can_delete_unique_constraint', 'collections_public.unique_constraint');

SELECT has_table_privilege('authenticated', 'collections_public.unique_constraint', 'INSERT');
SELECT has_table_privilege('authenticated', 'collections_public.unique_constraint', 'SELECT');
SELECT has_table_privilege('authenticated', 'collections_public.unique_constraint', 'UPDATE');
SELECT has_table_privilege('authenticated', 'collections_public.unique_constraint', 'DELETE');

ROLLBACK;
