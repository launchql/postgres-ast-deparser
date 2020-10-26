-- Deploy: schemas/launchql_public/tables/user_settings/constraints/user_settings_user_id_key to pg
-- made with <3 @ launchql.com

-- requires: schemas/launchql_public/schema
-- requires: schemas/launchql_public/tables/user_settings/table
-- requires: schemas/launchql_public/tables/user_settings/indexes/user_settings_user_id_idx

BEGIN;

ALTER TABLE "launchql_public".user_settings
    ADD CONSTRAINT user_settings_user_id_key UNIQUE (user_id);
COMMIT;
