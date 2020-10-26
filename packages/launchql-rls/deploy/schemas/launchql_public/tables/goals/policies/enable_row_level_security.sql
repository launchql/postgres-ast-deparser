-- Deploy: schemas/launchql_public/tables/goals/policies/enable_row_level_security to pg
-- made with <3 @ launchql.com

-- requires: schemas/launchql_public/schema
-- requires: schemas/launchql_public/tables/goals/table
-- requires: schemas/launchql_public/tables/goals/indexes/goals_vector_index

BEGIN;

ALTER TABLE "launchql_public".goals
    ENABLE ROW LEVEL SECURITY;
COMMIT;
