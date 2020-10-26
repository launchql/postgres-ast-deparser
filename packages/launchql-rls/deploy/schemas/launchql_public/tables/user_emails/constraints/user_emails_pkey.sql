-- Deploy: schemas/launchql_public/tables/user_emails/constraints/user_emails_pkey to pg
-- made with <3 @ launchql.com

-- requires: schemas/launchql_public/schema
-- requires: schemas/launchql_public/tables/user_emails/table
-- requires: schemas/launchql_public/tables/user_emails/columns/is_verified/alterations/alt0000000042

BEGIN;

ALTER TABLE "launchql_public".user_emails
    ADD CONSTRAINT user_emails_pkey PRIMARY KEY (id);
COMMIT;
