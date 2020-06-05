-- Deploy schemas/roles_private/procedures/registration/register_user to pg
-- requires: schemas/roles_private/schema
-- requires: schemas/roles_public/tables/roles/table
-- requires: schemas/roles_public/tables/user_emails/table
-- requires: schemas/roles_private/tables/user_secrets/table
-- requires: schemas/roles_public/tables/membership_invites/table
-- requires: schemas/roles_public/tables/invites/table

BEGIN;

CREATE FUNCTION roles_private.register_user (
  username text,
  display_name text,
  email text,
  email_is_verified bool,
  avatar_url text,
  PASSWORD text DEFAULT encode(gen_random_bytes(12), 'hex'),
  invite_token text DEFAULT NULL
)
  RETURNS roles_public.roles
  AS $$
DECLARE
  v_user roles_public.roles;
  v_membership_invite roles_public.membership_invites;
  v_invite roles_public.invites;
  v_invited_by_id uuid;
  v_inviter_approved_status boolean = FALSE;
BEGIN
  SELECT
    *
  FROM
    roles_private.register_role ('User',
      username,
      display_name,
      avatar_url) INTO v_user;
  -- check invites
  SELECT
    *
  FROM
    roles_public.invites invites
  WHERE
    invites.invite_token = register_user.invite_token
    AND EXTRACT(EPOCH FROM (expires_at - NOW())) > 0 INTO v_invite;
  -- if invite found...
  IF (FOUND) THEN
    IF (v_invite.email IS NOT NULL) THEN
      IF (v_invite.email::email = email::email) THEN
        email_is_verified = TRUE;
      ELSE
        RAISE
        EXCEPTION 'INVITE_WRONG_EMAIL';
      END IF;
    END IF;
    -- requester
    v_invited_by_id = v_invite.sender_id;
    -- checkout the invite status
    SELECT
      invites_approved
    FROM
      roles_private.user_secrets
    WHERE
      role_id = v_invited_by_id INTO v_inviter_approved_status;

    IF (v_inviter_approved_status) THEN
      -- potentially mark the invite task completed here
    END IF;

    -- expire it
    UPDATE
      roles_public.invites invites
    SET
      -- the reason you can expire this one is because its a regular invite, literally just access to get into the platform
      expires_at = NOW()
    WHERE
      invites.invite_token = register_user.invite_token;
  ELSE
    -- membership invites
    SELECT
      *
    FROM
      roles_public.membership_invites mvites
    WHERE
      mvites.invite_token = register_user.invite_token
      AND approved IS TRUE
      AND accepted IS FALSE
      AND EXTRACT(EPOCH FROM (expires_at - NOW())) > 0 INTO v_membership_invite;
    -- if membership invite found...
    IF (FOUND) THEN
      IF (v_membership_invite.email IS NOT NULL) THEN
        IF (v_membership_invite.email::email = email::email) THEN
          email_is_verified = TRUE;
        ELSE
          RAISE EXCEPTION 'INVITE_WRONG_EMAIL';
        END IF;
      END IF;
      -- requester
      v_invited_by_id = v_membership_invite.sender_id;
      -- checkout the invite status
      SELECT
        invites_approved
      FROM
        roles_private.user_secrets
      WHERE
        role_id = v_invited_by_id INTO v_inviter_approved_status;
      
      -- TODO remove this approved invites thingn when product opens
      IF (v_inviter_approved_status) THEN
        -- mark invite completed
      END IF;

      UPDATE
        roles_public.membership_invites invites
      SET
        role_id = v_user.id,
        accepted = TRUE,
        expires_at = NOW()
      WHERE
        invites.invite_token = register_user.invite_token;
        
    END IF;
  END IF;
  -- check email
  INSERT INTO roles_public.user_emails (role_id, email, is_verified)
    VALUES (v_user.id, email, email_is_verified);
  INSERT INTO roles_private.user_secrets (role_id, password_hash, invited_by_id)
    VALUES (v_user.id, crypt(PASSWORD, gen_salt('bf')), v_invited_by_id);
  RETURN v_user;
END;
$$
LANGUAGE 'plpgsql'
VOLATILE
SECURITY DEFINER;

GRANT EXECUTE ON FUNCTION roles_private.register_user TO anonymous;

-- only revoke because of default privs grant on this schema

REVOKE EXECUTE ON FUNCTION roles_private.register_user
FROM
  authenticated;

COMMIT;

