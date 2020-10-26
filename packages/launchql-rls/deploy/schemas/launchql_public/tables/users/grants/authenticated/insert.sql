-- Deploy: schemas/launchql_public/tables/users/grants/authenticated/insert to pg
-- made with <3 @ launchql.com

-- requires: schemas/launchql_public/schema
-- requires: schemas/launchql_public/tables/users/table
-- requires: schemas/launchql_public/tables/users/policies/authenticated_can_delete_on_users

BEGIN;
GRANT INSERT ON TABLE "launchql_public".users TO authenticated;
COMMIT;
