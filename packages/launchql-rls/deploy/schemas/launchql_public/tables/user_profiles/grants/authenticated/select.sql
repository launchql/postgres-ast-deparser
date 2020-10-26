-- Deploy: schemas/launchql_public/tables/user_profiles/grants/authenticated/select to pg
-- made with <3 @ launchql.com

-- requires: schemas/launchql_public/schema
-- requires: schemas/launchql_public/tables/user_profiles/table
-- requires: schemas/launchql_public/tables/user_profiles/policies/authenticated_can_select_on_user_profiles

BEGIN;
GRANT SELECT ON TABLE "launchql_public".user_profiles TO authenticated;
COMMIT;
