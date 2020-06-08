-- Verify schemas/collections_public/tables/primary_key_constraint/policies/project_primary_key_policy  on pg

BEGIN;

SELECT verify_policy ('can_select_primary_key_constraint', 'collections_public.primary_key_constraint');
SELECT verify_policy ('can_insert_primary_key_constraint', 'collections_public.primary_key_constraint');
SELECT verify_policy ('can_update_primary_key_constraint', 'collections_public.primary_key_constraint');
SELECT verify_policy ('can_delete_primary_key_constraint', 'collections_public.primary_key_constraint');

SELECT has_table_privilege('authenticated', 'collections_public.primary_key_constraint', 'INSERT');
SELECT has_table_privilege('authenticated', 'collections_public.primary_key_constraint', 'SELECT');
SELECT has_table_privilege('authenticated', 'collections_public.primary_key_constraint', 'UPDATE');
SELECT has_table_privilege('authenticated', 'collections_public.primary_key_constraint', 'DELETE');

ROLLBACK;
