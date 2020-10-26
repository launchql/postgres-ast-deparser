-- Deploy: schemas/launchql_public/tables/user_characteristics/columns/user_id/column to pg
-- made with <3 @ launchql.com

-- requires: schemas/launchql_public/schema
-- requires: schemas/launchql_public/tables/user_characteristics/table
-- requires: schemas/launchql_public/tables/user_characteristics/triggers/tg_timestamps

BEGIN;

ALTER TABLE "launchql_public".user_characteristics ADD COLUMN user_id uuid;
COMMIT;
