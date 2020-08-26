-- Deploy schemas/roles_public/tables/role_settings/policies/role_settings_policy to pg
-- requires: schemas/roles_public/schema
-- requires: schemas/roles_public/tables/role_settings/table
-- requires: schemas/roles_public/tables/role_settings/policies/enable_row_level_security
-- requires: schemas/roles_public/procedures/current_role_id
-- requires: schemas/permissions_private/procedures/permitted_on_role

BEGIN;

CREATE POLICY can_select_role_settings ON roles_public.role_settings
  FOR SELECT
    USING (permissions_private.permitted_on_role ('browse', 'role_setting', role_id));
CREATE POLICY can_insert_role_settings ON roles_public.role_settings
  FOR INSERT
    WITH CHECK (permissions_private.permitted_on_role ('edit', 'role_setting', role_id));
CREATE POLICY can_update_role_settings ON roles_public.role_settings
  FOR UPDATE
    USING (permissions_private.permitted_on_role ('edit', 'role_setting', role_id));

GRANT INSERT ON TABLE roles_public.role_settings TO authenticated;
GRANT SELECT ON TABLE roles_public.role_settings TO authenticated;

-- TODO update (only, props)
GRANT UPDATE ON TABLE roles_public.role_settings TO authenticated;

COMMIT;

