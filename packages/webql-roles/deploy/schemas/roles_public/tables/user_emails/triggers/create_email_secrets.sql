-- Deploy schemas/roles_public/tables/user_emails/triggers/create_email_secrets to pg

-- requires: schemas/roles_public/schema
-- requires: schemas/roles_public/tables/user_emails/table
-- requires: schemas/roles_private/tables/user_email_secrets/table
-- requires: schemas/roles_private/procedures/prepare_secrets_for_email_validation
-- requires: schemas/roles_private/procedures/create_email_verification_job

BEGIN;

CREATE FUNCTION roles_private.tg_create_email_secrets()
RETURNS TRIGGER AS $$
DECLARE
  v_secret roles_private.user_email_secrets;
BEGIN

  SELECT * FROM
    roles_private.prepare_secrets_for_email_validation(NEW.id)
  INTO v_secret;

  -- PERFORM
  --   app_jobs.add_job ('user_welcome__send_welcome',
  --     json_build_object(
  --       'email', NEW.email::text
  --     )
  --   );

  -- only TRUE in testing
  IF (NEW.is_verified IS FALSE) THEN
    PERFORM 
      roles_private.create_email_verification_job (
        NEW.email::text,
        NEW.id::text,
        v_secret.verification_token::text
      );
  END IF;

  RETURN NEW;
END;
$$
LANGUAGE 'plpgsql' VOLATILE SECURITY DEFINER;

CREATE TRIGGER create_email_secrets
AFTER INSERT ON roles_public.user_emails
FOR EACH ROW
EXECUTE PROCEDURE roles_private.tg_create_email_secrets ();

COMMIT;
