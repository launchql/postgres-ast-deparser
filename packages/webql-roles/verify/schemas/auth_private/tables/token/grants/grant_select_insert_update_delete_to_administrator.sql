-- Verify schemas/auth_private/tables/token/grants/grant_select_insert_update_delete_to_administrator on pg

BEGIN;


SELECT has_table_privilege('administrator', 'auth_private.token', 'SELECT');
SELECT has_table_privilege('administrator', 'auth_private.token', 'INSERT');
SELECT has_table_privilege('administrator', 'auth_private.token', 'UPDATE');
SELECT has_table_privilege('administrator', 'auth_private.token', 'DELETE');

ROLLBACK;
