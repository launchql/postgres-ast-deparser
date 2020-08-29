-- Revert schemas/roles_public/tables/roles/policies/roles_policy from pg

BEGIN;

REVOKE INSERT ON TABLE roles_public.roles FROM authenticated;
REVOKE SELECT ON TABLE roles_public.roles FROM authenticated;
REVOKE UPDATE ON TABLE roles_public.roles FROM authenticated;
REVOKE DELETE ON TABLE roles_public.roles FROM authenticated;

DROP POLICY can_select_roles ON roles_public.roles;
DROP POLICY can_insert_roles ON roles_public.roles;
DROP POLICY can_update_roles ON roles_public.roles;
DROP POLICY can_delete_roles ON roles_public.roles;

COMMIT;
