-- Deploy schemas/roles_public/procedures/send_verification_email to pg

-- requires: schemas/roles_public/schema
-- requires: schemas/roles_public/tables/roles/table
-- requires: schemas/roles_public/procedures/current_role_id
-- requires: schemas/roles_public/tables/user_emails/table
-- requires: schemas/roles_private/procedures/prepare_secrets_for_email_validation
-- requires: schemas/roles_private/procedures/create_email_verification_job
-- requires: schemas/status_private/procedures/user_completed_task
-- requires: schemas/status_public/procedures/user_achieved

BEGIN;

-- TODO use this field to only send a few at intervals
-- password_reset_email_sent_at

CREATE FUNCTION roles_public.send_verification_email(email email)
RETURNS boolean AS $$
DECLARE
  v_secret roles_private.user_email_secrets;
  v_email roles_public.user_emails;
  v_user roles_public.roles;
  v_verification_token text;
BEGIN

  SELECT * FROM roles_public.roles
    WHERE id = roles_public.current_role_id()
    INTO v_user;

  SELECT * FROM roles_public.user_emails e
    WHERE e.role_id = v_user.id
    AND e.email = send_verification_email.email
    INTO v_email;

  IF ( v_email.is_verified IS TRUE ) THEN
    IF (status_public.user_achieved('verify_email') IS FALSE) THEN
      PERFORM status_private.user_completed_task('verify_email');
    END IF;
    RETURN FALSE;
  END IF;

  SELECT * FROM 
  roles_private.prepare_secrets_for_email_validation(v_email.id)
  INTO v_secret;

  PERFORM 
    roles_private.create_email_verification_job (
      v_email.email::text,
      v_email.id::text,
      v_secret.verification_token::text
    );

  RETURN TRUE;
END;
$$
LANGUAGE 'plpgsql' VOLATILE SECURITY DEFINER;
GRANT EXECUTE ON FUNCTION roles_public.send_verification_email TO authenticated;

COMMIT;
