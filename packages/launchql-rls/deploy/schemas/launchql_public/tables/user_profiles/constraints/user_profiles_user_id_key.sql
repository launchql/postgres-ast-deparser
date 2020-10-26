-- Deploy: schemas/launchql_public/tables/user_profiles/constraints/user_profiles_user_id_key to pg
-- made with <3 @ launchql.com

-- requires: schemas/launchql_public/schema
-- requires: schemas/launchql_public/tables/user_profiles/table
-- requires: schemas/launchql_public/tables/user_profiles/indexes/user_profiles_user_id_idx

BEGIN;

ALTER TABLE "launchql_public".user_profiles
    ADD CONSTRAINT user_profiles_user_id_key UNIQUE (user_id);
COMMIT;
