-- Deploy: schemas/launchql_public/tables/users/columns/id/column to pg
-- made with <3 @ launchql.com

-- requires: schemas/launchql_public/schema
-- requires: schemas/launchql_public/tables/users/table
-- requires: schemas/launchql_public/tables/users/alterations/alt0000000006

BEGIN;

ALTER TABLE "launchql_public".users ADD COLUMN id uuid;
COMMIT;
