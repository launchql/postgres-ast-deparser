-- Verify schemas/collections_public/tables/table/policies/project_table_policy  on pg

BEGIN;

SELECT verify_policy ('can_select_table', 'collections_public.table');
SELECT verify_policy ('can_insert_table', 'collections_public.table');
SELECT verify_policy ('can_update_table', 'collections_public.table');
SELECT verify_policy ('can_delete_table', 'collections_public.table');

SELECT verify_function ('collections_private.table_policy_fn');


SELECT has_table_privilege('authenticated', 'collections_public.table', 'INSERT');
SELECT has_table_privilege('authenticated', 'collections_public.table', 'SELECT');
SELECT has_table_privilege('authenticated', 'collections_public.table', 'UPDATE');
SELECT has_table_privilege('authenticated', 'collections_public.table', 'DELETE');

ROLLBACK;
