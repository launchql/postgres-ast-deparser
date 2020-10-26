-- Deploy: schemas/launchql_public/tables/user_contacts/grants/authenticated/select to pg
-- made with <3 @ launchql.com

-- requires: schemas/launchql_public/schema
-- requires: schemas/launchql_public/tables/user_contacts/table
-- requires: schemas/launchql_public/tables/user_contacts/policies/authenticated_can_delete_on_user_contacts

BEGIN;
GRANT SELECT ON TABLE "launchql_public".user_contacts TO authenticated;
COMMIT;
