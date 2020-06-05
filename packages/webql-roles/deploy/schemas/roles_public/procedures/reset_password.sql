-- Deploy schemas/roles_public/procedures/reset_password to pg

-- requires: schemas/roles_public/schema
-- requires: schemas/roles_public/tables/roles/table
-- requires: schemas/roles_private/tables/user_secrets/table

BEGIN;

CREATE FUNCTION roles_public.reset_password (role_id uuid, reset_token text, new_password text)
    RETURNS roles_public.roles
AS $$
DECLARE
    v_user roles_public.roles;
    v_user_secret roles_private.user_secrets;
    v_reset_max_duration interval = interval '3 days';
    v_reset_max_attempts int = 10;
BEGIN
    SELECT
        u.* INTO v_user
    FROM
        roles_public.roles as u
    WHERE
        id = role_id;

    IF (NOT FOUND) THEN
      RETURN NULL;
    END IF;

    -- Load their secrets
    SELECT
        * INTO v_user_secret
    FROM
        roles_private.user_secrets
    WHERE
        roles_private.user_secrets.role_id = v_user.id;

    -- Have there been too many reset attempts?
    IF (v_user_secret.first_failed_reset_password_attempt IS NOT NULL
      AND v_user_secret.first_failed_reset_password_attempt > NOW() - v_reset_max_duration
      AND v_user_secret.reset_password_attempts >= v_reset_max_attempts) THEN
        RAISE
        EXCEPTION 'PASSWORD_RESET_LOCKED_EXCEED_ATTEMPTS';
    END IF;

    -- Not too many reset attempts, let's check the token
    IF v_user_secret.reset_password_token = reset_token THEN
        -- Excellent - they're legit; let's reset the password as requested
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
        RETURN v_user;
    ELSE
        -- Wrong token, bump all the attempt tracking figures
        UPDATE
            roles_private.user_secrets
        SET
            reset_password_attempts = (
                CASE WHEN first_failed_reset_password_attempt IS NULL
                    OR first_failed_reset_password_attempt < NOW() - v_reset_max_duration THEN
                    1
                ELSE
                    reset_password_attempts + 1
                END),
            first_failed_reset_password_attempt = (
                CASE WHEN first_failed_reset_password_attempt IS NULL
                    OR first_failed_reset_password_attempt < NOW() - v_reset_max_duration THEN
                    NOW()
                ELSE
                    first_failed_reset_password_attempt
                END)
        WHERE
            roles_private.user_secrets.role_id = v_user.id;
                RETURN NULL;
            END IF;
END;
$$
LANGUAGE 'plpgsql' VOLATILE
SECURITY DEFINER;

GRANT EXECUTE ON FUNCTION roles_public.reset_password to anonymous;

COMMIT;
