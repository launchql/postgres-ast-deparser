-- Deploy: schemas/launchql_public/tables/goals/columns/name/column to pg
-- made with <3 @ launchql.com

-- requires: schemas/launchql_public/schema
-- requires: schemas/launchql_public/tables/goals/table
-- requires: schemas/launchql_public/tables/goals/constraints/goals_pkey

BEGIN;

ALTER TABLE "launchql_public".goals ADD COLUMN name text;
COMMIT;
