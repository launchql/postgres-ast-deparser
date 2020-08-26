-- Verify schemas/roles_private/tables/user_secrets/policies/user_secrets_policy  on pg

BEGIN;

SELECT verify_policy ('can_select_user_secrets', 'roles_private.user_secrets');
SELECT verify_policy ('can_insert_user_secrets', 'roles_private.user_secrets');
SELECT verify_policy ('can_update_user_secrets', 'roles_private.user_secrets');
SELECT verify_policy ('can_delete_user_secrets', 'roles_private.user_secrets');

SELECT has_table_privilege('authenticated', 'roles_private.user_secrets', 'INSERT');
SELECT has_table_privilege('authenticated', 'roles_private.user_secrets', 'SELECT');
SELECT has_table_privilege('authenticated', 'roles_private.user_secrets', 'UPDATE');
SELECT has_table_privilege('authenticated', 'roles_private.user_secrets', 'DELETE');

ROLLBACK;
