-- Deploy: schemas/launchql_public/tables/goals/alterations/alt0000000067 to pg
-- made with <3 @ launchql.com

-- requires: schemas/launchql_public/schema
-- requires: schemas/launchql_public/tables/goals/table

BEGIN;

ALTER TABLE "launchql_public".goals
    DISABLE ROW LEVEL SECURITY;
COMMIT;
