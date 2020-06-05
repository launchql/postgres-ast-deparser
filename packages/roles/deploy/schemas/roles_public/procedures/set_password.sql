-- Deploy schemas/roles_public/procedures/set_password to pg
-- requires: schemas/roles_public/schema
-- requires: schemas/roles_public/tables/roles/table
-- requires: schemas/roles_private/tables/user_secrets/table
-- requires: schemas/roles_public/procedures/current_role_id
-- requires: schemas/status_private/procedures/user_completed_task

BEGIN;
CREATE FUNCTION roles_public.set_password (
  new_password text
)
  RETURNS boolean
  AS $$
DECLARE
  v_user roles_public.roles;
  v_user_secret roles_private.user_secrets;
BEGIN
  SELECT
    u.* INTO v_user
  FROM
    roles_public.roles AS u
  WHERE
    id = roles_public.current_role_id ();
  IF (NOT FOUND) THEN
    RETURN FALSE;
  END IF;
  -- not dry, copied from reset-password
  UPDATE
    roles_private.user_secrets
  SET
    password_hash = crypt(new_password, gen_salt('bf')),
    password_attempts = 0,
    first_failed_password_attempt = NULL,
    reset_password_token = NULL,
    reset_password_token_generated = NULL,
    reset_password_attempts = 0,
    first_failed_reset_password_attempt = NULL
  WHERE
    roles_private.user_secrets.role_id = v_user.id;
  -- complete
  PERFORM
    status_private.user_completed_task ('set_password',
      v_user.id);
  RETURN TRUE;
END;
$$
LANGUAGE 'plpgsql'
VOLATILE;
GRANT EXECUTE ON FUNCTION roles_public.set_password TO authenticated;
COMMIT;

