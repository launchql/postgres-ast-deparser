-- Revert schemas/roles_public/tables/invites/policies/invites_policy from pg

BEGIN;


REVOKE INSERT ON TABLE roles_public.invites FROM authenticated;
REVOKE SELECT ON TABLE roles_public.invites FROM authenticated;
REVOKE DELETE ON TABLE roles_public.invites FROM authenticated;
REVOKE UPDATE ON TABLE roles_public.invites FROM authenticated;


DROP POLICY can_select_invites ON roles_public.invites;
DROP POLICY can_insert_invites ON roles_public.invites;
DROP POLICY can_delete_invites ON roles_public.invites;
DROP POLICY can_update_invites ON roles_public.invites;

COMMIT;
