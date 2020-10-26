-- Deploy: schemas/launchql_public/tables/user_settings/columns/user_id/column to pg
-- made with <3 @ launchql.com

-- requires: schemas/launchql_public/schema
-- requires: schemas/launchql_public/tables/user_settings/table
-- requires: schemas/launchql_public/tables/user_settings/triggers/tg_timestamps

BEGIN;

ALTER TABLE "launchql_public".user_settings ADD COLUMN user_id uuid;
COMMIT;
