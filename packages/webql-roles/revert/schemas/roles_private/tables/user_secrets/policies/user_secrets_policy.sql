-- Revert schemas/roles_private/tables/user_secrets/policies/user_secrets_policy from pg

BEGIN;


REVOKE INSERT ON TABLE roles_private.user_secrets FROM authenticated;
REVOKE SELECT ON TABLE roles_private.user_secrets FROM authenticated;
REVOKE UPDATE ON TABLE roles_private.user_secrets FROM authenticated;
REVOKE DELETE ON TABLE roles_private.user_secrets FROM authenticated;

DROP POLICY can_select_user_secrets ON roles_private.user_secrets;
DROP POLICY can_insert_user_secrets ON roles_private.user_secrets;
DROP POLICY can_update_user_secrets ON roles_private.user_secrets;
DROP POLICY can_delete_user_secrets ON roles_private.user_secrets;

COMMIT;
