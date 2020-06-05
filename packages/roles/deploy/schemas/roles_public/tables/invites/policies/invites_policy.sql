-- Deploy schemas/roles_public/tables/invites/policies/invites_policy to pg

-- requires: schemas/roles_public/schema
-- requires: schemas/roles_public/tables/invites/table
-- requires: schemas/roles_public/tables/invites/policies/enable_row_level_security

BEGIN;

CREATE POLICY can_select_invites ON roles_public.invites
  FOR SELECT
  USING (
    roles_public.current_role_id() = sender_id
  );

CREATE POLICY can_insert_invites ON roles_public.invites
  FOR INSERT
  WITH CHECK (
    roles_public.current_role_id() = sender_id
  );

CREATE POLICY can_update_invites ON roles_public.invites
  FOR UPDATE
  USING (
    roles_public.current_role_id() = sender_id
  );

CREATE POLICY can_delete_invites ON roles_public.invites
  FOR DELETE
  USING (
    invite_used IS FALSE AND
    roles_public.current_role_id() = sender_id
  );

GRANT INSERT(email, expires_at) ON TABLE roles_public.invites TO authenticated;
GRANT UPDATE(expires_at) ON TABLE roles_public.invites TO authenticated;
GRANT SELECT ON TABLE roles_public.invites TO authenticated;
GRANT DELETE ON TABLE roles_public.invites TO authenticated;

COMMIT;
