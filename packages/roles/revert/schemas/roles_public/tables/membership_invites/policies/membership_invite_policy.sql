-- Revert schemas/roles_public/tables/membership_invites/policies/membership_invite_policy from pg

BEGIN;

REVOKE SELECT, INSERT, UPDATE, DELETE ON TABLE roles_public.membership_invites FROM authenticated;

DROP POLICY can_select_membership_invite ON roles_public.membership_invites;
DROP POLICY can_insert_membership_invite ON roles_public.membership_invites;
DROP POLICY can_update_membership_invite ON roles_public.membership_invites;
DROP POLICY can_delete_membership_invite ON roles_public.membership_invites;

COMMIT;
