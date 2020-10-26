-- Deploy: schemas/launchql_public/tables/user_contacts/columns/id/column to pg
-- made with <3 @ launchql.com

-- requires: schemas/launchql_public/schema
-- requires: schemas/launchql_public/tables/user_contacts/table
-- requires: schemas/launchql_public/tables/user_contacts/alterations/alt0000000058

BEGIN;

ALTER TABLE "launchql_public".user_contacts ADD COLUMN id uuid;
COMMIT;
