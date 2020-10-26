-- Deploy: schemas/launchql_public/tables/user_settings/policies/enable_row_level_security to pg
-- made with <3 @ launchql.com

-- requires: schemas/launchql_public/schema
-- requires: schemas/launchql_public/tables/user_settings/table
-- requires: schemas/launchql_public/tables/user_settings/indexes/user_location_gist_idx

BEGIN;

ALTER TABLE "launchql_public".user_settings
    ENABLE ROW LEVEL SECURITY;
COMMIT;
