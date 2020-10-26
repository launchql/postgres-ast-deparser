-- Deploy: schemas/launchql_public/tables/users/columns/id/alterations/alt0000000008 to pg
-- made with <3 @ launchql.com

-- requires: schemas/launchql_public/schema
-- requires: schemas/launchql_public/tables/users/table
-- requires: schemas/launchql_public/tables/users/columns/id/column
-- requires: schemas/launchql_public/tables/users/columns/id/alterations/alt0000000007

BEGIN;

ALTER TABLE "launchql_public".users 
    ALTER COLUMN id SET DEFAULT "launchql_private".uuid_generate_v4();
COMMIT;
