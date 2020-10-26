-- Deploy: schemas/launchql_public/tables/user_connections/columns/requester_id/column to pg
-- made with <3 @ launchql.com

-- requires: schemas/launchql_public/schema
-- requires: schemas/launchql_public/tables/user_connections/table
-- requires: schemas/launchql_public/tables/user_connections/triggers/tg_timestamps

BEGIN;

ALTER TABLE "launchql_public".user_connections ADD COLUMN requester_id uuid;
COMMIT;
