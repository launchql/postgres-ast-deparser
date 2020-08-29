-- Deploy schemas/roles_public/tables/roles/policies/roles_policy to pg
-- requires: schemas/roles_public/schema
-- requires: schemas/roles_public/tables/roles/policies/enable_row_level_security
-- requires: schemas/roles_public/tables/roles/table
-- requires: schemas/roles_public/types/role_type
-- requires: schemas/permissions_private/procedures/permitted_on_role

BEGIN;
CREATE POLICY can_select_roles ON roles_public.roles
  FOR SELECT
    USING (permissions_private.permitted_on_role ('read', 'role', id)
    OR permissions_private.permitted_on_role ('browse', 'role', organization_id));
CREATE POLICY can_insert_roles ON roles_public.roles
  FOR INSERT
    WITH CHECK (( CASE WHEN parent_id IS NOT NULL THEN
      -- Teams
      permissions_private.permitted_on_role ('add', 'team', parent_id)
    ELSE
      TRUE
    END));
CREATE POLICY can_update_roles ON roles_public.roles
  FOR UPDATE
    USING (permissions_private.permitted_on_role ('edit', 'role', id));
CREATE POLICY can_delete_roles ON roles_public.roles
  FOR DELETE
    USING (permissions_private.permitted_on_role ('destroy', 'role', id));
GRANT INSERT ON TABLE roles_public.roles TO authenticated;
GRANT SELECT ON TABLE roles_public.roles TO authenticated;
GRANT UPDATE (username, parent_id) ON TABLE roles_public.roles TO authenticated;
GRANT DELETE ON TABLE roles_public.roles TO authenticated;
COMMIT;

