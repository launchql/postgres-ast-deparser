-- Deploy: schemas/launchql_public/tables/user_emails/constraints/user_emails_email_key to pg
-- made with <3 @ launchql.com

-- requires: schemas/launchql_public/schema
-- requires: schemas/launchql_public/tables/user_emails/table
-- requires: schemas/launchql_public/tables/user_emails/constraints/user_emails_pkey

BEGIN;

ALTER TABLE "launchql_public".user_emails
    ADD CONSTRAINT user_emails_email_key UNIQUE (email);
COMMIT;
