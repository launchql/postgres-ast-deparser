-- Deploy: schemas/launchql_public/tables/user_settings/columns/location/column to pg
-- made with <3 @ launchql.com

-- requires: schemas/launchql_public/schema
-- requires: schemas/launchql_public/tables/user_settings/table
-- requires: schemas/launchql_public/tables/user_settings/columns/zip/column

BEGIN;

ALTER TABLE "launchql_public".user_settings ADD COLUMN location geometry (Point, 4326);
COMMIT;
