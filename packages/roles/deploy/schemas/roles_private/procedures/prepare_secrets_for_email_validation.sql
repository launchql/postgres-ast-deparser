-- Deploy schemas/roles_private/procedures/prepare_secrets_for_email_validation to pg

-- requires: schemas/roles_private/schema
-- requires: schemas/roles_public/tables/user_emails/table
-- requires: schemas/roles_private/tables/user_email_secrets/table

BEGIN;

CREATE FUNCTION roles_private.prepare_secrets_for_email_validation(
  email_id uuid
) RETURNS roles_private.user_email_secrets as $$
DECLARE
  v_secret roles_private.user_email_secrets;
  v_email roles_public.user_emails;
  v_verification_token text := encode(gen_random_bytes(16), 'hex');
BEGIN

  SELECT * FROM roles_public.user_emails
  INTO v_email
  WHERE id = email_id;

  IF (NOT FOUND) THEN
    RAISE EXCEPTION 'EMAIL_NOT_FOUND';
  END IF;

  SELECT * FROM roles_private.user_email_secrets
  INTO v_secret
  WHERE user_email_id = email_id;

  IF (NOT FOUND) THEN
    INSERT INTO roles_private.user_email_secrets
     (user_email_id, verification_token)
      VALUES
      (email_id, v_verification_token)
    RETURNING * INTO v_secret;
  END IF;

  IF (v_secret.verification_token IS NULL) THEN
    UPDATE roles_private.user_email_secrets
    SET verification_token=v_verification_token
    WHERE user_email_id = email_id;
  END IF;

  IF (v_email.is_verified IS TRUE) THEN
    UPDATE roles_private.user_email_secrets
    SET verification_token=NULL
    WHERE user_email_id = email_id
    RETURNING * INTO v_secret;
  END IF;

  RETURN v_secret;

END;
$$
LANGUAGE 'plpgsql' VOLATILE;

COMMIT;
