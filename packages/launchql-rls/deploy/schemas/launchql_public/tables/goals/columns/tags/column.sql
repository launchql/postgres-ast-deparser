-- Deploy: schemas/launchql_public/tables/goals/columns/tags/column to pg
-- made with <3 @ launchql.com

-- requires: schemas/launchql_public/schema
-- requires: schemas/launchql_public/tables/goals/table
-- requires: schemas/launchql_public/tables/goals/columns/sub_head/column

BEGIN;

ALTER TABLE "launchql_public".goals ADD COLUMN tags citext[];
COMMIT;
