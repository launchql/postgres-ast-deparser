-- Deploy: schemas/launchql_public/tables/user_emails/policies/authenticated_can_update_on_user_emails to pg
-- made with <3 @ launchql.com

-- requires: schemas/launchql_public/schema
-- requires: schemas/launchql_public/tables/user_emails/table
-- requires: schemas/launchql_public/tables/user_emails/policies/enable_row_level_security
-- requires: schemas/launchql_public/tables/user_emails/policies/authenticated_can_insert_on_user_emails

BEGIN;
CREATE POLICY authenticated_can_update_on_user_emails ON "launchql_public".user_emails FOR UPDATE TO authenticated USING ( user_id = "launchql_public".get_current_user_id() );
COMMIT;
