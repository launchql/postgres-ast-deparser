-- Deploy: schemas/launchql_public/tables/user_characteristics/grants/authenticated/select to pg
-- made with <3 @ launchql.com

-- requires: schemas/launchql_public/schema
-- requires: schemas/launchql_public/tables/user_characteristics/table
-- requires: schemas/launchql_public/tables/user_characteristics/policies/authenticated_can_delete_on_user_characteristics

BEGIN;
GRANT SELECT ON TABLE "launchql_public".user_characteristics TO authenticated;
COMMIT;
