-- Deploy: schemas/launchql_public/tables/user_profiles/alterations/alt0000000045 to pg
-- made with <3 @ launchql.com

-- requires: schemas/launchql_public/schema
-- requires: schemas/launchql_public/tables/user_profiles/table

BEGIN;

ALTER TABLE "launchql_public".user_profiles
    DISABLE ROW LEVEL SECURITY;
COMMIT;
