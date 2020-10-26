-- Deploy: schemas/launchql_public/tables/user_settings/columns/id/column to pg
-- made with <3 @ launchql.com

-- requires: schemas/launchql_public/schema
-- requires: schemas/launchql_public/tables/user_settings/table
-- requires: schemas/launchql_public/tables/user_settings/alterations/alt0000000050

BEGIN;

ALTER TABLE "launchql_public".user_settings ADD COLUMN id uuid;
COMMIT;
