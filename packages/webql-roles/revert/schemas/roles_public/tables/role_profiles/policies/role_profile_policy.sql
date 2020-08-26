-- Revert schemas/roles_public/tables/role_profiles/policies/role_profile_policy from pg

BEGIN;


REVOKE INSERT ON TABLE roles_public.role_profiles FROM authenticated;
REVOKE SELECT ON TABLE roles_public.role_profiles FROM authenticated;
REVOKE UPDATE ON TABLE roles_public.role_profiles FROM authenticated;

DROP POLICY can_select_role_profiles ON roles_public.role_profiles;
DROP POLICY can_insert_role_profiles ON roles_public.role_profiles;
DROP POLICY can_update_role_profiles ON roles_public.role_profiles;

COMMIT;
