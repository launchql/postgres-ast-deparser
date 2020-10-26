-- Deploy: schemas/launchql_public/tables/goals/columns/icon/column to pg
-- made with <3 @ launchql.com

-- requires: schemas/launchql_public/schema
-- requires: schemas/launchql_public/tables/goals/table
-- requires: schemas/launchql_public/tables/goals/columns/short_name/column

BEGIN;

ALTER TABLE "launchql_public".goals ADD COLUMN icon text;
COMMIT;
