-- Deploy: schemas/launchql_public/tables/user_connections/triggers/tg_timestamps to pg
-- made with <3 @ launchql.com

-- requires: schemas/launchql_public/schema
-- requires: schemas/launchql_private/schema
-- requires: schemas/launchql_private/trigger_fns/tg_timestamps
-- requires: schemas/launchql_public/tables/user_connections/table
-- requires: schemas/launchql_public/tables/user_connections/triggers/tg_peoplestamps

BEGIN;

ALTER TABLE "launchql_public".user_connections ADD COLUMN created_at TIMESTAMPTZ;
ALTER TABLE "launchql_public".user_connections ALTER COLUMN created_at SET DEFAULT NOW();
ALTER TABLE "launchql_public".user_connections ADD COLUMN updated_at TIMESTAMPTZ;
ALTER TABLE "launchql_public".user_connections ALTER COLUMN updated_at SET DEFAULT NOW();
CREATE TRIGGER tg_timestamps
BEFORE UPDATE OR INSERT ON "launchql_public".user_connections
FOR EACH ROW
EXECUTE PROCEDURE "launchql_private".tg_timestamps();
COMMIT;
