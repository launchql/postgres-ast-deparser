-- Deploy: schemas/launchql_public/tables/users/columns/type/column to pg
-- made with <3 @ launchql.com

-- requires: schemas/launchql_public/schema
-- requires: schemas/launchql_public/tables/users/table

BEGIN;

ALTER TABLE "launchql_public".users ADD COLUMN type int;
COMMIT;
