-- Verify schemas/files_public/tables/files/policies/files_policy  on pg

BEGIN;

SELECT verify_policy ('can_select_files', 'files_public.files');
SELECT verify_policy ('can_insert_files', 'files_public.files');
SELECT verify_policy ('can_update_files', 'files_public.files');
SELECT verify_policy ('can_delete_files', 'files_public.files');

SELECT has_table_privilege('authenticated', 'files_public.files', 'INSERT');
SELECT has_table_privilege('authenticated', 'files_public.files', 'SELECT');
SELECT has_table_privilege('authenticated', 'files_public.files', 'UPDATE');
SELECT has_table_privilege('authenticated', 'files_public.files', 'DELETE');

ROLLBACK;
