-- Deploy schemas/roles_private/procedures/create_email_verification_job to pg
-- requires: schemas/roles_private/schema

BEGIN;
CREATE FUNCTION roles_private.create_email_verification_job (email text, user_email_id text, verification_token text)
  RETURNS void
  AS $$
BEGIN
  IF (verification_token IS NOT NULL) THEN
    PERFORM
      app_jobs.add_job ('user_emails__send_verification',
        json_build_object(
          'email', email,
          'user_email_id', user_email_id,
          'verification_token', verification_token
        )
      );
  END IF;
END;
$$
LANGUAGE 'plpgsql'
VOLATILE SECURITY DEFINER;
COMMIT;

