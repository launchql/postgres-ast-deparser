-- Deploy: schemas/launchql_public/tables/goals/triggers/tg_peoplestamps to pg
-- made with <3 @ launchql.com

-- requires: schemas/launchql_public/schema
-- requires: schemas/launchql_public/tables/goals/table
-- requires: schemas/launchql_private/trigger_fns/tg_peoplestamps
-- requires: schemas/launchql_public/tables/goals/columns/search/column

BEGIN;

ALTER TABLE "launchql_public".goals ADD COLUMN created_by UUID;
ALTER TABLE "launchql_public".goals ADD COLUMN updated_by UUID;
CREATE TRIGGER tg_peoplestamps
BEFORE UPDATE OR INSERT ON "launchql_public".goals
FOR EACH ROW
EXECUTE PROCEDURE "launchql_private".tg_peoplestamps();
COMMIT;
