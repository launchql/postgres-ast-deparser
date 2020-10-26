-- Deploy: schemas/launchql_public/tables/users/policies/authenticated_can_update_on_users to pg
-- made with <3 @ launchql.com

-- requires: schemas/launchql_public/schema
-- requires: schemas/launchql_public/tables/users/table
-- requires: schemas/launchql_public/tables/users/policies/enable_row_level_security
-- requires: schemas/launchql_public/tables/users/policies/authenticated_can_insert_on_users

BEGIN;
CREATE POLICY authenticated_can_update_on_users ON "launchql_public".users FOR UPDATE TO authenticated USING ( id = "launchql_public".get_current_user_id() );
COMMIT;
