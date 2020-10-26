-- Deploy: schemas/launchql_public/tables/goals/columns/id/alterations/alt0000000069 to pg
-- made with <3 @ launchql.com

-- requires: schemas/launchql_public/schema
-- requires: schemas/launchql_public/tables/goals/table
-- requires: schemas/launchql_public/tables/goals/columns/id/column
-- requires: schemas/launchql_public/tables/goals/columns/id/alterations/alt0000000068

BEGIN;

ALTER TABLE "launchql_public".goals 
    ALTER COLUMN id SET DEFAULT "launchql_private".uuid_generate_v4();
COMMIT;
