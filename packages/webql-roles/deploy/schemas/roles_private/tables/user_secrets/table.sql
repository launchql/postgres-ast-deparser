-- Deploy schemas/roles_private/tables/user_secrets/table to pg
-- requires: schemas/roles_private/schema
-- requires: schemas/roles_public/tables/roles/table

BEGIN;

CREATE TABLE roles_private.user_secrets (
    role_id uuid PRIMARY KEY REFERENCES roles_public.roles (id) ON DELETE CASCADE,
    invites_approved boolean NOT NULL DEFAULT FALSE,
    invited_by_id uuid NULL,
    password_hash text NOT NULL, -- password
    password_attempts int NOT NULL DEFAULT 0,
    first_failed_password_attempt timestamptz,
    reset_password_token text, -- password reset
    reset_password_token_generated timestamptz,
    reset_password_attempts int NOT NULL DEFAULT 0,
    first_failed_reset_password_attempt timestamptz,
    multi_factor_attempts int NOT NULL DEFAULT 0, -- multi factor tokens
    first_failed_multi_factor_attempt timestamptz,
    multi_factor_secret text -- multi factor secrets
);

COMMENT ON TABLE roles_private.user_secrets IS 'The contents of this table should never be visible to the user. Contains data mostly related to authentication.';

COMMENT ON COLUMN roles_private.user_secrets.multi_factor_secret IS 'Secret for the Time-Based One-time Password (TOTP) algorithm defined in RFC 6238';

COMMIT;

