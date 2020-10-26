-- Deploy: schemas/launchql_private/tables/user_secrets/grants/authenticated/select to pg
-- made with <3 @ launchql.com

-- requires: schemas/launchql_private/schema
-- requires: schemas/launchql_private/tables/user_secrets/table
-- requires: schemas/launchql_private/tables/user_secrets/policies/authenticated_can_delete_on_user_secrets

BEGIN;
GRANT SELECT ON TABLE "launchql_private".user_secrets TO authenticated;
COMMIT;
