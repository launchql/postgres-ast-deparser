-- Deploy: schemas/launchql_public/tables/users/policies/authenticated_can_select_on_users to pg
-- made with <3 @ launchql.com

-- requires: schemas/launchql_public/schema
-- requires: schemas/launchql_public/tables/users/table
-- requires: schemas/launchql_public/tables/users/grants/authenticated/delete
-- requires: schemas/launchql_public/tables/users/policies/enable_row_level_security

BEGIN;
CREATE POLICY authenticated_can_select_on_users ON "launchql_public".users FOR SELECT TO authenticated USING ( TRUE );
COMMIT;
