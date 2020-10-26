-- Deploy: schemas/launchql_public/tables/user_profiles/policies/enable_row_level_security to pg
-- made with <3 @ launchql.com

-- requires: schemas/launchql_public/schema
-- requires: schemas/launchql_public/tables/user_profiles/table
-- requires: schemas/launchql_public/tables/user_profiles/constraints/user_profiles_user_id_key

BEGIN;

ALTER TABLE "launchql_public".user_profiles
    ENABLE ROW LEVEL SECURITY;
COMMIT;
