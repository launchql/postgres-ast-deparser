-- Deploy: schemas/launchql_public/tables/user_settings/columns/search_radius/column to pg
-- made with <3 @ launchql.com

-- requires: schemas/launchql_public/schema
-- requires: schemas/launchql_public/tables/user_settings/table
-- requires: schemas/launchql_public/tables/user_settings/constraints/user_settings_pkey

BEGIN;

ALTER TABLE "launchql_public".user_settings ADD COLUMN search_radius numeric;
COMMIT;
