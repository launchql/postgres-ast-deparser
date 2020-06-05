-- Deploy schemas/roles_private/tables/user_secrets/policies/user_secrets_policy to pg

-- requires: schemas/roles_private/schema
-- requires: schemas/roles_private/tables/user_secrets/table
-- requires: schemas/roles_private/tables/user_secrets/policies/enable_row_level_security

BEGIN;

CREATE POLICY can_select_user_secrets ON roles_private.user_secrets
  FOR SELECT
  USING (
    roles_public.current_role_id() = role_id
  );

CREATE POLICY can_insert_user_secrets ON roles_private.user_secrets
  FOR INSERT
  WITH CHECK (
    roles_public.current_role_id() = role_id
  );

CREATE POLICY can_update_user_secrets ON roles_private.user_secrets
  FOR UPDATE
  USING (
    roles_public.current_role_id() = role_id
  );

CREATE POLICY can_delete_user_secrets ON roles_private.user_secrets
  FOR DELETE
  USING (
    roles_public.current_role_id() = role_id
  );


GRANT INSERT ON TABLE roles_private.user_secrets TO authenticated;
GRANT SELECT ON TABLE roles_private.user_secrets TO authenticated;
GRANT UPDATE ON TABLE roles_private.user_secrets TO authenticated;
GRANT DELETE ON TABLE roles_private.user_secrets TO authenticated;


COMMIT;
