-- Deploy schemas/meta_public/tables/user_auth_module/table to pg

-- requires: schemas/meta_public/schema

BEGIN;

CREATE TABLE meta_public.user_auth_module (
    id uuid PRIMARY KEY DEFAULT uuid_generate_v4 (),
    api_id uuid NOT NULL REFERENCES meta_public.apis (id),
    sign_in_function text NOT NULL DEFAULT 'login',
    sign_up_function text NOT NULL DEFAULT 'register',
    set_password_function text NOT NULL DEFAULT 'set_password',
    reset_password_function text NOT NULL DEFAULT 'reset_password',
    forgot_password_function text NOT NULL DEFAULT 'forgot_password',
    send_verification_email_function text NOT NULL DEFAULT  'send_verification_email',
    verify_email_function text NOT NULL DEFAULT 'verify_email',
    UNIQUE(api_id)
);

COMMIT;
