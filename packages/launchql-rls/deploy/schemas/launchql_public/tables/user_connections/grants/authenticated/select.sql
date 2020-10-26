-- Deploy: schemas/launchql_public/tables/user_connections/grants/authenticated/select to pg
-- made with <3 @ launchql.com

-- requires: schemas/launchql_public/schema
-- requires: schemas/launchql_public/tables/user_connections/table
-- requires: schemas/launchql_public/tables/user_connections/policies/authenticated_can_delete_on_user_connections

BEGIN;
GRANT SELECT ON TABLE "launchql_public".user_connections TO authenticated;
COMMIT;
