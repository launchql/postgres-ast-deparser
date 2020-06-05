-- Deploy schemas/roles_public/tables/role_profiles/policies/role_profile_policy to pg
-- requires: schemas/roles_public/schema
-- requires: schemas/roles_public/tables/role_profiles/table
-- requires: schemas/roles_public/tables/role_profiles/policies/enable_row_level_security
-- requires: schemas/roles_public/procedures/current_role_id
-- requires: schemas/permissions_private/procedures/permitted_on_role


BEGIN;
CREATE POLICY can_select_role_profiles ON roles_public.role_profiles
  FOR SELECT
    USING (permissions_private.permitted_on_role ('browse', 'role_profile', role_id));
CREATE POLICY can_insert_role_profiles ON roles_public.role_profiles
  FOR INSERT
    WITH CHECK (permissions_private.permitted_on_role ('edit', 'role_profile', role_id));
CREATE POLICY can_update_role_profiles ON roles_public.role_profiles
  FOR UPDATE
    USING (permissions_private.permitted_on_role ('edit', 'role_profile', role_id));
GRANT INSERT ON TABLE roles_public.role_profiles TO authenticated;
GRANT SELECT ON TABLE roles_public.role_profiles TO authenticated;
GRANT UPDATE (display_name, avatar_url, bio, url, company, LOCATION) ON TABLE roles_public.role_profiles TO authenticated;
COMMIT;

