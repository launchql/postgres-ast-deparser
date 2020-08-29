-- Deploy schemas/permissions_public/tables/profile/policies/profile_policy to pg

-- requires: schemas/roles_private/procedures/authorization/is_member_of_organization
-- requires: schemas/roles_private/procedures/authorization/is_admin_of
-- requires: schemas/roles_public/procedures/current_role_id

-- requires: schemas/permissions_public/schema
-- requires: schemas/permissions_public/tables/profile/table
-- requires: schemas/permissions_public/tables/profile/policies/enable_row_level_security

BEGIN;

CREATE POLICY can_select_profile ON permissions_public.profile
  FOR SELECT
  USING (
    roles_private.is_member_of_organization(roles_public.current_role_id(), organization_id)
  );

CREATE POLICY can_insert_profile ON permissions_public.profile
  FOR INSERT
  WITH CHECK (
    roles_private.is_admin_of(roles_public.current_role_id(), organization_id)
  );

CREATE POLICY can_update_profile ON permissions_public.profile
  FOR UPDATE
  USING (
    roles_private.is_admin_of(roles_public.current_role_id(), organization_id)
  );

CREATE POLICY can_delete_profile ON permissions_public.profile
  FOR DELETE
  USING (
    roles_private.is_admin_of(roles_public.current_role_id(), organization_id)
  );


GRANT INSERT ON TABLE permissions_public.profile TO authenticated;
GRANT SELECT ON TABLE permissions_public.profile TO authenticated;
GRANT UPDATE ON TABLE permissions_public.profile TO authenticated;
GRANT DELETE ON TABLE permissions_public.profile TO authenticated;


COMMIT;
