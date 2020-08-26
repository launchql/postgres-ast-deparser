-- Deploy schemas/roles_public/tables/memberships/policies/membership_policy to pg
-- requires: schemas/roles_private/schema
-- requires: schemas/roles_public/schema
-- requires: schemas/roles_private/procedures/actor_role_admin_owner_authorized_profiles
-- requires: schemas/roles_public/tables/memberships/table
-- requires: schemas/roles_public/tables/memberships/policies/enable_row_level_security
-- requires: schemas/roles_public/procedures/current_role_id
-- requires: schemas/permissions_private/procedures/permitted_on_role

BEGIN;
CREATE POLICY can_select_membership ON roles_public.memberships
  FOR SELECT
    USING (roles_public.current_role_id () = role_id
    OR permissions_private.permitted_on_role ('browse', 'user', group_id));
CREATE POLICY can_insert_membership ON roles_public.memberships
  FOR INSERT
    WITH CHECK (permissions_private.permitted_on_role ('add', 'user', group_id)
    AND roles_private.actor_role_admin_owner_authorized_profiles (roles_public.current_role_id (), group_id, profile_id, organization_id));
CREATE POLICY can_update_membership ON roles_public.memberships
  FOR UPDATE
    USING (permissions_private.permitted_on_role ('edit', 'user', group_id)
    AND roles_private.actor_role_admin_owner_authorized_profiles (roles_public.current_role_id (), group_id, profile_id, organization_id));
CREATE POLICY can_delete_membership ON roles_public.memberships
  FOR DELETE
    USING (roles_public.current_role_id () = role_id
    OR (permissions_private.permitted_on_role ('destroy', 'user', group_id)
    AND roles_private.actor_role_admin_owner_authorized_profiles (roles_public.current_role_id (), group_id, profile_id, organization_id)));
GRANT SELECT ON TABLE roles_public.memberships TO authenticated;
GRANT INSERT ON TABLE roles_public.memberships TO authenticated;
GRANT UPDATE ON TABLE roles_public.memberships TO authenticated;
GRANT DELETE ON TABLE roles_public.memberships TO authenticated;
COMMIT;

