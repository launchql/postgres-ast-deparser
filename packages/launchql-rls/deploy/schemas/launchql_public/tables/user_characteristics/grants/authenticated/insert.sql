-- Deploy: schemas/launchql_public/tables/user_characteristics/grants/authenticated/insert to pg
-- made with <3 @ launchql.com

-- requires: schemas/launchql_public/schema
-- requires: schemas/launchql_public/tables/user_characteristics/table
-- requires: schemas/launchql_public/tables/user_characteristics/grants/authenticated/select

BEGIN;
GRANT INSERT ON TABLE "launchql_public".user_characteristics TO authenticated;
COMMIT;
