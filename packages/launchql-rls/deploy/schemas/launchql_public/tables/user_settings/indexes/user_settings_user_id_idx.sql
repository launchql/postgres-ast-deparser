-- Deploy: schemas/launchql_public/tables/user_settings/indexes/user_settings_user_id_idx to pg
-- made with <3 @ launchql.com

-- requires: schemas/launchql_public/schema
-- requires: schemas/launchql_public/tables/user_settings/table
-- requires: schemas/launchql_public/tables/user_settings/constraints/user_settings_user_id_fkey

BEGIN;

CREATE INDEX user_settings_user_id_idx ON "launchql_public".user_settings (user_id);
COMMIT;
