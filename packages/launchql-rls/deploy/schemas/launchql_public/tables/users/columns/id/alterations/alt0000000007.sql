-- Deploy: schemas/launchql_public/tables/users/columns/id/alterations/alt0000000007 to pg
-- made with <3 @ launchql.com

-- requires: schemas/launchql_public/schema
-- requires: schemas/launchql_public/tables/users/table
-- requires: schemas/launchql_public/tables/users/columns/id/column

BEGIN;

ALTER TABLE "launchql_public".users 
    ALTER COLUMN id SET NOT NULL;
COMMIT;
