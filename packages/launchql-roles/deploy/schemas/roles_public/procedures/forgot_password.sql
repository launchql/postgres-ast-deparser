-- Deploy schemas/roles_public/procedures/forgot_password to pg
-- requires: schemas/roles_public/schema
-- requires: schemas/roles_private/tables/user_secrets/table
-- requires: schemas/roles_public/tables/user_emails/table
BEGIN;

CREATE FUNCTION roles_public.forgot_password (email email)
    RETURNS boolean
AS $$
DECLARE
    v_user_email roles_public.user_emails;
    v_reset_token text;
    v_reset_min_duration_between_emails interval = interval '30 minutes';
    v_reset_max_duration interval = interval '3 days';
BEGIN
    -- Find the matching user_email
    SELECT
        user_emails.* INTO v_user_email
    FROM
        roles_public.user_emails
    WHERE
        user_emails.email = forgot_password.email::email
    ORDER BY
        is_verified DESC,
        created_at DESC;
    -- bail out
    IF (NOT FOUND) THEN
        RETURN FALSE;
    END IF;
    -- See if we've triggered a reset recently
    IF EXISTS (
            SELECT
                1
            FROM
                roles_private.user_email_secrets
            WHERE
                user_email_id = v_user_email.id AND password_reset_email_sent_at IS NOT NULL AND password_reset_email_sent_at > NOW() - v_reset_min_duration_between_emails) THEN
            RETURN TRUE;
    END IF;
    -- Fetch or generate reset token
    UPDATE
        roles_private.user_secrets
    SET
        reset_password_token = ( CASE WHEN reset_password_token IS NULL
                OR reset_password_token_generated < NOW() - v_reset_max_duration THEN
                encode(gen_random_bytes(6), 'hex')
            ELSE
                reset_password_token
            END),
        reset_password_token_generated = ( CASE WHEN reset_password_token IS NULL
                OR reset_password_token_generated < NOW() - v_reset_max_duration THEN
                NOW()
            ELSE
                reset_password_token_generated
END)
WHERE
    role_id = v_user_email.role_id
RETURNING
    reset_password_token INTO v_reset_token;
-- Don't allow spamming an email
UPDATE
    roles_private.user_email_secrets
SET
    password_reset_email_sent_at = NOW()
WHERE
    user_email_id = v_user_email.id;
-- Trigger email send
PERFORM
    app_jobs.add_job ('user__forgot_password',
        json_build_object('id', v_user_email.role_id, 'email', v_user_email.email::text, 'token', v_reset_token));
RETURN TRUE;
END;
$$
LANGUAGE 'plpgsql' VOLATILE
SECURITY DEFINER;

GRANT EXECUTE ON FUNCTION roles_public.forgot_password TO anonymous;

COMMIT;

