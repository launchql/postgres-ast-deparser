-- Deploy: schemas/launchql_public/tables/user_contacts/policies/authenticated_can_select_on_user_contacts to pg
-- made with <3 @ launchql.com

-- requires: schemas/launchql_public/schema
-- requires: schemas/launchql_public/tables/user_contacts/table
-- requires: schemas/launchql_public/tables/user_contacts/policies/enable_row_level_security

BEGIN;
CREATE POLICY authenticated_can_select_on_user_contacts ON "launchql_public".user_contacts FOR SELECT TO authenticated USING ( user_id = "launchql_public".get_current_user_id() );
COMMIT;
