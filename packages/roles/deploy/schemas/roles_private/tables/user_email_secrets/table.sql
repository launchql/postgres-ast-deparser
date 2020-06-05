-- Deploy schemas/roles_private/tables/user_email_secrets/table to pg

-- requires: schemas/roles_private/schema
-- requires: schemas/roles_public/tables/user_emails/table

BEGIN;

CREATE TABLE roles_private.user_email_secrets (
    user_email_id uuid PRIMARY KEY REFERENCES roles_public.user_emails ON DELETE CASCADE,
    verification_token text,
    -- verification_email_sent_at timestamptz
    password_reset_email_sent_at timestamptz
);

COMMENT ON TABLE roles_private.user_email_secrets IS
  E'The contents of this table should never be visible to the user. Contains data mostly related to email verification and avoiding spamming users.';

COMMIT;
