-- Revert schemas/permissions_public/tables/profile/policies/profile_policy from pg

BEGIN;


REVOKE INSERT ON TABLE permissions_public.profile FROM authenticated;
REVOKE SELECT ON TABLE permissions_public.profile FROM authenticated;
REVOKE UPDATE ON TABLE permissions_public.profile FROM authenticated;
REVOKE DELETE ON TABLE permissions_public.profile FROM authenticated;


DROP POLICY can_select_profile ON permissions_public.profile;
DROP POLICY can_insert_profile ON permissions_public.profile;
DROP POLICY can_update_profile ON permissions_public.profile;
DROP POLICY can_delete_profile ON permissions_public.profile;

DROP FUNCTION permissions_private.profile_policy_fn;

COMMIT;
