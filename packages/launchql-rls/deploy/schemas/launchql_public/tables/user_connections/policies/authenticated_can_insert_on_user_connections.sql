-- Deploy: schemas/launchql_public/tables/user_connections/policies/authenticated_can_insert_on_user_connections to pg
-- made with <3 @ launchql.com

-- requires: schemas/launchql_public/schema
-- requires: schemas/launchql_public/tables/user_connections/table
-- requires: schemas/launchql_public/tables/user_connections/grants/authenticated/update
-- requires: schemas/launchql_public/tables/user_connections/policies/enable_row_level_security

BEGIN;
CREATE POLICY authenticated_can_insert_on_user_connections ON "launchql_public".user_connections FOR INSERT TO authenticated WITH CHECK ( requester_id = "launchql_public".get_current_user_id() );
COMMIT;
