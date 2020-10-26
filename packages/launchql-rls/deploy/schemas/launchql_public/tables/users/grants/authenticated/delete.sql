-- Deploy: schemas/launchql_public/tables/users/grants/authenticated/delete to pg
-- made with <3 @ launchql.com

-- requires: schemas/launchql_public/schema
-- requires: schemas/launchql_public/tables/users/table
-- requires: schemas/launchql_public/tables/users/grants/authenticated/update

BEGIN;
GRANT DELETE ON TABLE "launchql_public".users TO authenticated;
COMMIT;
