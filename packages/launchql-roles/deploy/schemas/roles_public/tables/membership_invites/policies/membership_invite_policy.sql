-- Deploy schemas/roles_public/tables/membership_invites/policies/membership_invite_policy to pg
-- requires: schemas/roles_private/schema
-- requires: schemas/roles_public/schema
-- requires: schemas/roles_public/tables/membership_invites/table
-- requires: schemas/roles_public/tables/membership_invites/policies/enable_row_level_security
-- requires: schemas/roles_public/procedures/current_role_id
-- requires: schemas/permissions_private/procedures/permitted_on_role

BEGIN;
CREATE POLICY can_select_membership_invite ON roles_public.membership_invites
  FOR SELECT
    USING (((roles_public.current_role_id () = sender_id)
    OR permissions_private.permitted_on_role ('browse', 'invite', group_id))
    OR ((role_id IS NOT NULL
    AND roles_public.current_role_id () = role_id)
    AND EXTRACT(EPOCH FROM (expires_at - NOW())) > 0));
CREATE POLICY can_insert_membership_invite ON roles_public.membership_invites
  FOR INSERT
    WITH CHECK (permissions_private.permitted_on_role ('add', 'invite', group_id)
    AND roles_private.actor_role_admin_owner_authorized_profiles (roles_public.current_role_id (), group_id, profile_id, organization_id));
CREATE POLICY can_update_membership_invite ON roles_public.membership_invites
  FOR UPDATE
    USING (((role_id IS NOT NULL
    AND roles_public.current_role_id () = role_id)
    AND EXTRACT(EPOCH FROM (expires_at - NOW())) > 0)
      OR (permissions_private.permitted_on_role ('edit', 'invite', group_id)
      AND roles_private.actor_role_admin_owner_authorized_profiles (roles_public.current_role_id (), group_id, profile_id, organization_id)));
CREATE POLICY can_delete_membership_invite ON roles_public.membership_invites
  FOR DELETE
    USING ((role_id IS NOT NULL
    AND roles_public.current_role_id () = role_id)
    OR (roles_public.current_role_id () = sender_id)
    OR (permissions_private.permitted_on_role ('destroy', 'invite', group_id)
    AND roles_private.actor_role_admin_owner_authorized_profiles (roles_public.current_role_id (), group_id, profile_id, organization_id)));
GRANT SELECT ON TABLE roles_public.membership_invites TO authenticated;
GRANT INSERT (role_id, email, profile_id, group_id, organization_id, expires_at) ON TABLE roles_public.membership_invites TO authenticated;
GRANT UPDATE (approved, accepted, expires_at) ON TABLE roles_public.membership_invites TO authenticated;
GRANT DELETE ON TABLE roles_public.membership_invites TO authenticated;
COMMIT;

