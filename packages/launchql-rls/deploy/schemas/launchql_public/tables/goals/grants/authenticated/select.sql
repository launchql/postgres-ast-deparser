-- Deploy: schemas/launchql_public/tables/goals/grants/authenticated/select to pg
-- made with <3 @ launchql.com

-- requires: schemas/launchql_public/schema
-- requires: schemas/launchql_public/tables/goals/table
-- requires: schemas/launchql_public/tables/goals/policies/authenticated_can_select_on_goals

BEGIN;
GRANT SELECT ON TABLE "launchql_public".goals TO authenticated;
COMMIT;
