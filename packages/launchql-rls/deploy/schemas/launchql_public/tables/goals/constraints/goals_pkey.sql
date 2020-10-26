-- Deploy: schemas/launchql_public/tables/goals/constraints/goals_pkey to pg
-- made with <3 @ launchql.com

-- requires: schemas/launchql_public/schema
-- requires: schemas/launchql_public/tables/goals/table
-- requires: schemas/launchql_public/tables/goals/columns/id/alterations/alt0000000069

BEGIN;

ALTER TABLE "launchql_public".goals
    ADD CONSTRAINT goals_pkey PRIMARY KEY (id);
COMMIT;
