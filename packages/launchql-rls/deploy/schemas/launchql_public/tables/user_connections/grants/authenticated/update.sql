-- Deploy: schemas/launchql_public/tables/user_connections/grants/authenticated/update to pg
-- made with <3 @ launchql.com

-- requires: schemas/launchql_public/schema
-- requires: schemas/launchql_public/tables/user_connections/table
-- requires: schemas/launchql_public/tables/user_connections/policies/authenticated_can_update_on_user_connections

BEGIN;
GRANT UPDATE ( accepted ) ON TABLE "launchql_public".user_connections TO authenticated;
COMMIT;
