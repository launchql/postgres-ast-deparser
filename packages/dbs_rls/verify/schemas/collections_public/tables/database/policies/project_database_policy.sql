-- Verify schemas/collections_public/tables/database/policies/project_database_policy  on pg

BEGIN;

SELECT verify_policy ('can_select_database', 'collections_public.database');
SELECT verify_policy ('can_insert_database', 'collections_public.database');
SELECT verify_policy ('can_update_database', 'collections_public.database');
SELECT verify_policy ('can_delete_database', 'collections_public.database');

SELECT has_table_privilege('authenticated', 'collections_public.database', 'INSERT');
SELECT has_table_privilege('authenticated', 'collections_public.database', 'SELECT');
SELECT has_table_privilege('authenticated', 'collections_public.database', 'UPDATE');
SELECT has_table_privilege('authenticated', 'collections_public.database', 'DELETE');

ROLLBACK;
