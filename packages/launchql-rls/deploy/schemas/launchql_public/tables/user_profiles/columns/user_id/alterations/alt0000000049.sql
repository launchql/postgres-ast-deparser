-- Deploy: schemas/launchql_public/tables/user_profiles/columns/user_id/alterations/alt0000000049 to pg
-- made with <3 @ launchql.com

-- requires: schemas/launchql_public/schema
-- requires: schemas/launchql_public/tables/user_profiles/table
-- requires: schemas/launchql_public/tables/user_profiles/columns/user_id/column

BEGIN;

ALTER TABLE "launchql_public".user_profiles 
    ALTER COLUMN user_id SET NOT NULL;
COMMIT;
