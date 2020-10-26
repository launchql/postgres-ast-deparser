-- Deploy: schemas/launchql_public/tables/user_contacts/columns/id/alterations/alt0000000059 to pg
-- made with <3 @ launchql.com

-- requires: schemas/launchql_public/schema
-- requires: schemas/launchql_public/tables/user_contacts/table
-- requires: schemas/launchql_public/tables/user_contacts/columns/id/column

BEGIN;

ALTER TABLE "launchql_public".user_contacts 
    ALTER COLUMN id SET NOT NULL;
COMMIT;
