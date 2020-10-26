-- Deploy: schemas/launchql_public/tables/user_emails/grants/authenticated/insert to pg
-- made with <3 @ launchql.com

-- requires: schemas/launchql_public/schema
-- requires: schemas/launchql_public/tables/user_emails/table
-- requires: schemas/launchql_public/tables/user_emails/grants/authenticated/select

BEGIN;
GRANT INSERT ON TABLE "launchql_public".user_emails TO authenticated;
COMMIT;
