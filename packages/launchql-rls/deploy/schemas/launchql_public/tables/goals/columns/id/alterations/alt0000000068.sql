-- Deploy: schemas/launchql_public/tables/goals/columns/id/alterations/alt0000000068 to pg
-- made with <3 @ launchql.com

-- requires: schemas/launchql_public/schema
-- requires: schemas/launchql_public/tables/goals/table
-- requires: schemas/launchql_public/tables/goals/columns/id/column

BEGIN;

ALTER TABLE "launchql_public".goals 
    ALTER COLUMN id SET NOT NULL;
COMMIT;
