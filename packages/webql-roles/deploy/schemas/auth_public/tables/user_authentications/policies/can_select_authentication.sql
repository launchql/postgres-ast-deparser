-- Deploy schemas/auth_public/tables/user_authentications/policies/can_select_authentication to pg

-- requires: schemas/auth_public/schema
-- requires: schemas/auth_public/tables/user_authentications/table
-- requires: schemas/auth_public/tables/user_authentications/policies/enable_row_level_security

BEGIN;

CREATE POLICY select_own ON auth_public.user_authentications
  FOR SELECT

  USING (
    role_id = roles_public.current_role_id()
  );


GRANT SELECT ON TABLE auth_public.user_authentications TO authenticated;



COMMIT;
