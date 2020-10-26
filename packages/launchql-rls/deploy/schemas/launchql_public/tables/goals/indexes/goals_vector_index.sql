-- Deploy: schemas/launchql_public/tables/goals/indexes/goals_vector_index to pg
-- made with <3 @ launchql.com

-- requires: schemas/launchql_public/schema
-- requires: schemas/launchql_public/tables/goals/table
-- requires: schemas/launchql_public/tables/goals/constraints/goals_name_key

BEGIN;
CREATE INDEX goals_vector_index ON "launchql_public".goals USING GIN (search);
COMMIT;
