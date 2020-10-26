-- Deploy: schemas/launchql_public/tables/goals/constraints/goals_name_key to pg
-- made with <3 @ launchql.com

-- requires: schemas/launchql_public/schema
-- requires: schemas/launchql_public/tables/goals/table
-- requires: schemas/launchql_public/tables/goals/triggers/goals_search_tsv_update_tg

BEGIN;

ALTER TABLE "launchql_public".goals
    ADD CONSTRAINT goals_name_key UNIQUE (name);
COMMIT;
