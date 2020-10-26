-- Deploy: schemas/launchql_public/tables/user_settings/grants/authenticated/select to pg
-- made with <3 @ launchql.com

-- requires: schemas/launchql_public/schema
-- requires: schemas/launchql_public/tables/user_settings/table
-- requires: schemas/launchql_public/tables/user_settings/policies/authenticated_can_delete_on_user_settings

BEGIN;
GRANT SELECT ON TABLE "launchql_public".user_settings TO authenticated;
COMMIT;
