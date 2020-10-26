-- Deploy: schemas/launchql_public/tables/user_settings/indexes/user_location_gist_idx to pg
-- made with <3 @ launchql.com

-- requires: schemas/launchql_public/schema
-- requires: schemas/launchql_public/tables/user_settings/table
-- requires: schemas/launchql_public/tables/user_settings/constraints/user_settings_user_id_key

BEGIN;
CREATE INDEX user_location_gist_idx ON "launchql_public".user_settings USING GIST (location);
COMMIT;
