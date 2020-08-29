-- Deploy schemas/roles_public/procedures/submit_invite_code to pg
-- requires: schemas/roles_public/schema
-- requires: schemas/roles_public/tables/roles/table
-- requires: schemas/roles_public/tables/invites/table
-- requires: schemas/roles_public/tables/user_emails/table
-- requires: schemas/roles_public/procedures/current_role_id
-- requires: schemas/status_private/procedures/user_completed_task
-- requires: schemas/roles_private/tables/user_secrets/table

BEGIN;
CREATE FUNCTION roles_public.submit_invite_code (
  token text
)
  RETURNS boolean
  AS $$
DECLARE
  v_user roles_public.roles;
  v_email roles_public.user_emails;
  v_invite roles_public.invites;
  v_inviter_secrets roles_private.user_secrets;
BEGIN
  SELECT
    *
  FROM
    roles_public.roles
  WHERE
    id = roles_public.current_role_id ()
  INTO v_user;

  IF (NOT FOUND) THEN
    RAISE EXCEPTION 'OBJECT_NOT_FOUND';
  END IF;
  -- get the invite
  SELECT
    *
  FROM
    roles_public.invites
  WHERE
    invite_token = token
  INTO v_invite;
  IF (NOT FOUND) THEN
    RAISE EXCEPTION 'INVITE_NOT_FOUND';
  END IF;

  -- get the email
  SELECT
    *
  FROM
    roles_public.user_emails
  WHERE
    email = v_invite.email
    AND role_id = v_user.id
  INTO v_email;

  IF (NOT FOUND) THEN
    RAISE EXCEPTION 'INVITE_EMAIL_NOT_FOUND';
  END IF;

  -- update invite to used
  UPDATE
    roles_public.invites
  SET
    invite_used = TRUE
  WHERE
    id = v_invite.id;
  -- give credit on secrets
  UPDATE roles_private.user_secrets
    SET invited_by_id = v_invite.sender_id
  WHERE role_id = v_user.id;


  -- get the inviter secrets
  -- later this can just be removed
  SELECT
    *
  FROM
    roles_private.user_secrets
  WHERE
    role_id = v_invite.sender_id
  INTO v_inviter_secrets;

  IF (v_inviter_secrets.invites_approved) THEN 
    -- they did it
    PERFORM
      status_private.user_completed_task ('invite_code');
  ELSE
    RAISE EXCEPTION 'INVITE_DOES_NOT_GRANT_ACCESS';
  END IF;

  -- its ok
  RETURN TRUE;
END;
$$
LANGUAGE 'plpgsql'
VOLATILE
SECURITY DEFINER;
-- it aint your owned invite
GRANT EXECUTE ON FUNCTION roles_public.submit_invite_code TO authenticated;

COMMIT;

