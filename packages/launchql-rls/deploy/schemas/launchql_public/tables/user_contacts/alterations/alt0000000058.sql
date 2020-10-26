-- Deploy: schemas/launchql_public/tables/user_contacts/alterations/alt0000000058 to pg
-- made with <3 @ launchql.com

-- requires: schemas/launchql_public/schema
-- requires: schemas/launchql_public/tables/user_contacts/table

BEGIN;

ALTER TABLE "launchql_public".user_contacts
    DISABLE ROW LEVEL SECURITY;
COMMIT;
