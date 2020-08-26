-- Verify schemas/collections_public/tables/field/policies/project_field_policy  on pg

BEGIN;

SELECT verify_policy ('can_select_field', 'collections_public.field');
SELECT verify_policy ('can_insert_field', 'collections_public.field');
SELECT verify_policy ('can_update_field', 'collections_public.field');
SELECT verify_policy ('can_delete_field', 'collections_public.field');

SELECT has_table_privilege('authenticated', 'collections_public.field', 'INSERT');
SELECT has_table_privilege('authenticated', 'collections_public.field', 'SELECT');
SELECT has_table_privilege('authenticated', 'collections_public.field', 'UPDATE');
SELECT has_table_privilege('authenticated', 'collections_public.field', 'DELETE');

ROLLBACK;
