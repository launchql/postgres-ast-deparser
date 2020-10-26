-- Deploy: schemas/launchql_public/tables/users/columns/type/alterations/alt0000000009 to pg
-- made with <3 @ launchql.com

-- requires: schemas/launchql_public/schema
-- requires: schemas/launchql_public/tables/users/table
-- requires: schemas/launchql_public/tables/users/columns/type/column

BEGIN;

ALTER TABLE "launchql_public".users 
    ALTER COLUMN type SET DEFAULT 0;
COMMIT;
