-- Deploy schemas/roles_public/procedures/verify_email to pg
-- requires: schemas/roles_public/schema
-- requires: schemas/roles_public/tables/user_emails/table
-- requires: schemas/roles_private/tables/user_email_secrets/table
-- requires: schemas/roles_public/procedures/current_role_id
-- requires: schemas/status_private/procedures/user_completed_task

BEGIN;
CREATE FUNCTION roles_public.verify_email (
  id uuid,
  token text
)
  RETURNS boolean
  AS $$
DECLARE
  v_secret roles_private.user_email_secrets;
  v_email roles_public.user_emails;
  v_role_id uuid;
BEGIN

  SELECT
    roles_public.current_role_id () INTO v_role_id;

  -- Find Email
  -- if user is not logged in, find the email without scoping it to user
  -- if user is, scope it
  IF (v_role_id IS NULL) THEN
    SELECT
      *
    FROM
      roles_public.user_emails e
    WHERE
      e.id = verify_email.id INTO v_email;
  ELSE
    SELECT
      *
    FROM
      roles_public.user_emails e
    WHERE
      e.role_id = v_role_id
      AND e.id = verify_email.id INTO v_email;
  END IF;
  
  -- if no email found return false
  IF (NOT FOUND) THEN
    RETURN FALSE;
  END IF;

  -- before we go further
  -- the email had already been verified, and just return true in that case
  IF (v_email.is_verified) THEN
    RETURN TRUE;
  END IF;


  -- look up the secrets
  SELECT
    *
  FROM
    roles_private.user_email_secrets s
  WHERE
    s.user_email_id = verify_email.id
    AND s.verification_token IS NOT NULL
    AND s.verification_token = verify_email.token INTO v_secret;

  IF (NOT FOUND) THEN
    RETURN FALSE;
  END IF;

  UPDATE
    roles_private.user_email_secrets s
  SET
    verification_token = NULL
  WHERE
    s.user_email_id = verify_email.id;
  UPDATE
    roles_public.user_emails e
  SET
    is_verified = TRUE
  WHERE
    e.id = verify_email.id;
  -- use v_email.role_id since v_role_id can be null
  
  PERFORM status_private.user_completed_task('verify_email', v_email.role_id);

  RETURN TRUE;
END;
$$
LANGUAGE 'plpgsql'
VOLATILE
SECURITY DEFINER;
GRANT EXECUTE ON FUNCTION roles_public.verify_email TO anonymous, authenticated;
COMMIT;

