-- Deploy: schemas/launchql_public/tables/user_emails/indexes/user_emails_user_id_idx to pg
-- made with <3 @ launchql.com

-- requires: schemas/launchql_public/schema
-- requires: schemas/launchql_public/tables/user_emails/table
-- requires: schemas/launchql_public/tables/user_emails/constraints/user_emails_user_id_fkey

BEGIN;

CREATE INDEX user_emails_user_id_idx ON "launchql_public".user_emails (user_id);
COMMIT;
