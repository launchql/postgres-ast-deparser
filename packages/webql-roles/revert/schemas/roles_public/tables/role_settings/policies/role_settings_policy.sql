-- Revert schemas/roles_public/tables/role_settings/policies/role_settings_policy from pg

BEGIN;

REVOKE INSERT ON TABLE roles_public.role_settings FROM authenticated;
REVOKE SELECT ON TABLE roles_public.role_settings FROM authenticated;
REVOKE UPDATE ON TABLE roles_public.role_settings FROM authenticated;

DROP POLICY can_select_role_settings ON roles_public.role_settings;
DROP POLICY can_insert_role_settings ON roles_public.role_settings;
DROP POLICY can_update_role_settings ON roles_public.role_settings;

COMMIT;
