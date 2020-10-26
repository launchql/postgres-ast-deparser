-- Deploy: schemas/launchql_public/tables/users/grants/authenticated/update to pg
-- made with <3 @ launchql.com

-- requires: schemas/launchql_public/schema
-- requires: schemas/launchql_public/tables/users/table
-- requires: schemas/launchql_public/tables/users/grants/authenticated/insert

BEGIN;
GRANT UPDATE ON TABLE "launchql_public".users TO authenticated;
COMMIT;
