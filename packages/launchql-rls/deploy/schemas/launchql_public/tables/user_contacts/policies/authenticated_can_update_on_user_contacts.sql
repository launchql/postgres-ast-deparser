-- Deploy: schemas/launchql_public/tables/user_contacts/policies/authenticated_can_update_on_user_contacts to pg
-- made with <3 @ launchql.com

-- requires: schemas/launchql_public/schema
-- requires: schemas/launchql_public/tables/user_contacts/table
-- requires: schemas/launchql_public/tables/user_contacts/policies/enable_row_level_security
-- requires: schemas/launchql_public/tables/user_contacts/policies/authenticated_can_insert_on_user_contacts

BEGIN;
CREATE POLICY authenticated_can_update_on_user_contacts ON "launchql_public".user_contacts FOR UPDATE TO authenticated USING ( user_id = "launchql_public".get_current_user_id() );
COMMIT;
