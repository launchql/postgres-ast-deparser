-- Deploy: schemas/launchql_public/tables/user_contacts/grants/authenticated/update to pg
-- made with <3 @ launchql.com

-- requires: schemas/launchql_public/schema
-- requires: schemas/launchql_public/tables/user_contacts/table
-- requires: schemas/launchql_public/tables/user_contacts/grants/authenticated/insert

BEGIN;
GRANT UPDATE ON TABLE "launchql_public".user_contacts TO authenticated;
COMMIT;
