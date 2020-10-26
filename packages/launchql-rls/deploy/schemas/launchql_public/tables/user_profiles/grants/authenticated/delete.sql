-- Deploy: schemas/launchql_public/tables/user_profiles/grants/authenticated/delete to pg
-- made with <3 @ launchql.com

-- requires: schemas/launchql_public/schema
-- requires: schemas/launchql_public/tables/user_profiles/table
-- requires: schemas/launchql_public/tables/user_profiles/grants/authenticated/update

BEGIN;
GRANT DELETE ON TABLE "launchql_public".user_profiles TO authenticated;
COMMIT;
