-- Deploy: schemas/launchql_public/tables/user_connections/grants/authenticated/delete to pg
-- made with <3 @ launchql.com

-- requires: schemas/launchql_public/schema
-- requires: schemas/launchql_public/tables/user_connections/table
-- requires: schemas/launchql_public/tables/user_connections/grants/authenticated/select

BEGIN;
GRANT DELETE ON TABLE "launchql_public".user_connections TO authenticated;
COMMIT;
