-- Deploy schemas/roles_public/procedures/sign_up to pg
-- requires: schemas/roles_public/schema
-- requires: schemas/roles_public/tables/roles/table
-- requires: schemas/auth_private/tables/token/table
-- requires: schemas/auth_private/types/token_type
-- requires: schemas/roles_public/tables/user_emails/table
-- requires: schemas/roles_private/tables/user_secrets/table
-- requires: schemas/roles_public/procedures/available_username
-- requires: schemas/status_private/procedures/user_completed_task

BEGIN;
CREATE FUNCTION roles_public.sign_up (
  display_name text,
  email text,
  password text,
  invite_token text DEFAULT NULL,
  accept_terms boolean DEFAULT FALSE
)
  RETURNS auth_private.token
  AS $$
DECLARE
  v_user roles_public.roles;
  v_token auth_private.token;
  v_supplied_password boolean := FALSE;
BEGIN

  IF (password IS NOT NULL) THEN
    SELECT true INTO v_supplied_password;
  ELSE 
    SELECT encode(gen_random_bytes(12), 'hex') INTO password;
  END IF;
    
  SELECT
    *
  FROM
    roles_private.register_user (NULL,
      display_name,
      email,
      FALSE,
      NULL,
      password,
      invite_token) INTO v_user;
  
  IF (accept_terms) THEN
    PERFORM status_private.user_completed_task('accept_terms', v_user.id);
  END IF;

  IF (v_supplied_password) THEN
    PERFORM status_private.user_completed_task('set_password', v_user.id);
  END IF;

  -- RETURN v_user;
  INSERT INTO auth_private.token (type, role_id)
      VALUES ('auth'::auth_private.token_type, v_user.id)
    RETURNING
      * INTO v_token;

    RETURN v_token;
END;
$$
LANGUAGE plpgsql
VOLATILE
SECURITY DEFINER;
GRANT EXECUTE ON FUNCTION roles_public.sign_up TO anonymous;
COMMENT ON FUNCTION roles_public.sign_up IS 'Creates a user signs them up.';
COMMIT;

