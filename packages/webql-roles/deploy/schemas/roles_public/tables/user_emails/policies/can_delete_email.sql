-- Deploy schemas/roles_public/tables/user_emails/policies/can_delete_email to pg

-- requires: schemas/roles_public/schema
-- requires: schemas/roles_public/tables/user_emails/table
-- requires: schemas/roles_public/tables/user_emails/policies/enable_row_level_security

BEGIN;

CREATE POLICY delete_own ON roles_public.user_emails
  FOR DELETE

  USING (
    role_id = roles_public.current_role_id()
  );


GRANT DELETE ON TABLE roles_public.user_emails TO authenticated;



COMMIT;
