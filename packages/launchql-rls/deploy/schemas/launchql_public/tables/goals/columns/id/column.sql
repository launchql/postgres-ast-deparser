-- Deploy: schemas/launchql_public/tables/goals/columns/id/column to pg
-- made with <3 @ launchql.com

-- requires: schemas/launchql_public/schema
-- requires: schemas/launchql_public/tables/goals/table
-- requires: schemas/launchql_public/tables/goals/alterations/alt0000000067

BEGIN;

ALTER TABLE "launchql_public".goals ADD COLUMN id uuid;
COMMIT;
