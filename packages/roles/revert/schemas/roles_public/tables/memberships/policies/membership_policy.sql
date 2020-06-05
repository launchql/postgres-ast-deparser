-- Revert schemas/roles_public/tables/memberships/policies/membership_policy from pg

BEGIN;

REVOKE SELECT, INSERT, UPDATE, DELETE ON TABLE roles_public.memberships FROM authenticated;

DROP POLICY can_select_membership ON roles_public.memberships;
DROP POLICY can_insert_membership ON roles_public.memberships;
DROP POLICY can_update_membership ON roles_public.memberships;
DROP POLICY can_delete_membership ON roles_public.memberships;

COMMIT;
