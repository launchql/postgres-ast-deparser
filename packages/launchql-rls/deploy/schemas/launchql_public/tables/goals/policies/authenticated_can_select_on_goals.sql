-- Deploy: schemas/launchql_public/tables/goals/policies/authenticated_can_select_on_goals to pg
-- made with <3 @ launchql.com

-- requires: schemas/launchql_public/schema
-- requires: schemas/launchql_public/tables/goals/table
-- requires: schemas/launchql_public/tables/goals/policies/enable_row_level_security

BEGIN;
CREATE POLICY authenticated_can_select_on_goals ON "launchql_public".goals FOR SELECT TO authenticated USING ( TRUE );
COMMIT;
