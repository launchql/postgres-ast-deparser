-- Deploy: schemas/launchql_public/tables/user_contacts/columns/id/alterations/alt0000000060 to pg
-- made with <3 @ launchql.com

-- requires: schemas/launchql_public/schema
-- requires: schemas/launchql_public/tables/user_contacts/table
-- requires: schemas/launchql_public/tables/user_contacts/columns/id/column
-- requires: schemas/launchql_public/tables/user_contacts/columns/id/alterations/alt0000000059

BEGIN;

ALTER TABLE "launchql_public".user_contacts 
    ALTER COLUMN id SET DEFAULT "launchql_private".uuid_generate_v4();
COMMIT;
