-- Deploy: schemas/launchql_public/tables/user_profiles/indexes/user_profiles_user_id_idx to pg
-- made with <3 @ launchql.com

-- requires: schemas/launchql_public/schema
-- requires: schemas/launchql_public/tables/user_profiles/table
-- requires: schemas/launchql_public/tables/user_profiles/constraints/user_profiles_user_id_fkey

BEGIN;

CREATE INDEX user_profiles_user_id_idx ON "launchql_public".user_profiles (user_id);
COMMIT;
