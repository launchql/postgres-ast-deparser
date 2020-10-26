-- Deploy: schemas/launchql_public/tables/user_emails/grants/authenticated/select to pg
-- made with <3 @ launchql.com

-- requires: schemas/launchql_public/schema
-- requires: schemas/launchql_public/tables/user_emails/table
-- requires: schemas/launchql_public/tables/user_emails/policies/authenticated_can_delete_on_user_emails

BEGIN;
GRANT SELECT ON TABLE "launchql_public".user_emails TO authenticated;
COMMIT;
