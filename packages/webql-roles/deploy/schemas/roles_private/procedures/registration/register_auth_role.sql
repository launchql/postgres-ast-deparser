-- Deploy schemas/roles_private/procedures/registration/register_auth_role to pg

-- requires: schemas/roles_private/schema
-- requires: schemas/roles_private/procedures/registration/register_user
-- requires: schemas/auth_public/tables/user_authentications/table
-- requires: schemas/auth_private/tables/user_authentication_secrets/table

BEGIN;

CREATE FUNCTION roles_private.register_auth_role (
  f_service text,
  f_identifier text,
  f_profile json,
  f_auth_details json,
  f_email_is_verified boolean DEFAULT FALSE
)
    RETURNS roles_public.roles
AS $$
DECLARE
    v_user roles_public.roles;
    v_email email;
    v_display_name text;
    v_username text;
    v_avatar_url text;
    v_user_authentication_id uuid;
BEGIN

    -- Extract data from the user’s OAuth profile data.
    v_email := f_profile ->> 'email';
    v_display_name := f_profile ->> 'display_name';
    v_username := f_profile ->> 'username';
    v_avatar_url := f_profile ->> 'avatar_url';

    -- Create the user
    v_user = roles_private.register_user(
      username => v_username,
      display_name => v_display_name,
      email => v_email,
      email_is_verified => f_email_is_verified,
      avatar_url => v_avatar_url
    );

    -- Insert the user’s private account data (e.g. OAuth tokens)
    INSERT INTO auth_public.user_authentications (role_id,
      service, identifier, details)
      VALUES (v_user.id, f_service, f_identifier, f_profile)
      RETURNING id INTO v_user_authentication_id;

    INSERT INTO auth_private.user_authentication_secrets (user_authentication_id, details)
      VALUES (v_user_authentication_id, f_auth_details);

    RETURN v_user;
END;
$$
LANGUAGE plpgsql VOLATILE;

GRANT EXECUTE ON FUNCTION roles_private.register_auth_role to anonymous;
-- only revoke because of default privs grant on this schema
REVOKE EXECUTE ON FUNCTION roles_private.register_auth_role from authenticated;

COMMENT ON FUNCTION roles_private.register_auth_role IS E'Used to register a user from information gleaned from OAuth.';

COMMIT;
