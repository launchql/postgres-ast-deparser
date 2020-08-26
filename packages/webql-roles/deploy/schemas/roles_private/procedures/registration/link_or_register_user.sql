-- Deploy schemas/roles_private/procedures/registration/link_or_register_user to pg

-- requires: schemas/roles_private/schema
-- requires: schemas/roles_public/tables/roles/table
-- requires: schemas/roles_public/tables/role_profiles/table
-- requires: schemas/roles_public/tables/user_emails/table
-- requires: schemas/roles_private/procedures/registration/register_user
-- requires: schemas/auth_public/tables/user_authentications/table
-- requires: schemas/auth_private/tables/user_authentication_secrets/table

BEGIN;

CREATE FUNCTION roles_private.link_or_register_user (
  f_role_id uuid,
  f_service text,
  f_identifier text,
  f_profile json,
  f_auth_details json
)
    RETURNS roles_public.roles
AS $$
DECLARE
    v_matched_role_id uuid;
    v_matched_authentication_id uuid;
    v_email email;
    v_display_name text;
    v_avatar_url text;
    v_user roles_public.roles;
    v_user_email roles_public.user_emails;
BEGIN
    -- See if a user account already matches these details
    SELECT
        id,
        role_id INTO v_matched_authentication_id,
        v_matched_role_id
    FROM
        auth_public.user_authentications
    WHERE
        service = f_service
        AND identifier = f_identifier
    LIMIT 1;

    IF v_matched_role_id IS NOT NULL AND f_role_id IS NOT NULL AND v_matched_role_id <> f_role_id THEN
        raise
        exception 'A different user already has this account linked.'
            USING errcode = 'TAKEN';
    END IF;

    v_email = f_profile ->> 'email';
    v_display_name := f_profile ->> 'display_name';
    v_avatar_url := f_profile ->> 'avatar_url';

    IF v_matched_authentication_id IS NULL THEN
        IF f_role_id IS NOT NULL THEN
            -- Link new account to logged in user account
            INSERT INTO auth_public.user_authentications (role_id, service, identifier, details)
            VALUES (f_role_id, f_service, f_identifier, f_profile)
        RETURNING
            id, role_id INTO v_matched_authentication_id, v_matched_role_id;
            INSERT INTO auth_private.user_authentication_secrets (user_authentication_id, details)
            VALUES (v_matched_authentication_id, f_auth_details);
        elsif v_email IS NOT NULL THEN
            -- See if the email is registered
            SELECT
                * INTO v_user_email
            FROM
                roles_public.user_emails
            WHERE
                email = v_email
                AND is_verified IS TRUE;
            IF v_user_email IS NOT NULL THEN
                -- User exists!
                INSERT INTO auth_public.user_authentications (role_id, service, identifier, details)
                VALUES (v_user_email.role_id, f_service, f_identifier, f_profile)
            RETURNING
                id, role_id INTO v_matched_authentication_id, v_matched_role_id;
                INSERT INTO auth_private.user_authentication_secrets (user_authentication_id, details)
                VALUES (v_matched_authentication_id, f_auth_details);
            END IF;
        END IF;
    END IF;
    IF v_matched_role_id IS NULL AND f_role_id IS NULL AND v_matched_authentication_id IS NULL THEN
        -- Create and return a new user account
        RETURN roles_private.register_auth_role (
            f_service,
            f_identifier,
            f_profile,
            f_auth_details,
            TRUE);
    ELSE
        IF v_matched_authentication_id IS NOT NULL THEN
            UPDATE
                auth_public.user_authentications
            SET
                details = f_profile
            WHERE
                id = v_matched_authentication_id;

            UPDATE
                auth_private.user_authentication_secrets
            SET
                details = f_auth_details
            WHERE
                user_authentication_id = v_matched_authentication_id;

            UPDATE
                roles_public.role_profiles
            SET
                display_name = coalesce(roles_public.role_profiles.display_name, v_display_name),
                avatar_url = coalesce(roles_public.role_profiles.avatar_url, v_avatar_url)
            WHERE
                role_id = v_matched_role_id;

            SELECT * FROM roles_public.roles WHERE id=v_matched_role_id INTO v_user;

            RETURN v_user;
        ELSE
            -- v_matched_authentication_id is null
            -- -> v_matched_role_id is null (they're paired)
            -- -> f_role_id is not null (because the if clause above)
            -- -> v_matched_authentication_id is not null (because of the separate if block above creating a user_authentications)
            -- -> contradiction.
            raise
            exception 'This should not occur';
        END IF;
    END IF;
END;
$$
LANGUAGE 'plpgsql' VOLATILE SECURITY DEFINER;

GRANT EXECUTE ON FUNCTION roles_private.link_or_register_user to anonymous;

COMMENT ON FUNCTION roles_private.link_or_register_user IS E'If you are logged in, this will link an additional OAuth login to your account if necessary. If you are logged out it may find if an account already exists (based on OAuth details or email address) and return that, or create a new user account if necessary.';

COMMIT;
