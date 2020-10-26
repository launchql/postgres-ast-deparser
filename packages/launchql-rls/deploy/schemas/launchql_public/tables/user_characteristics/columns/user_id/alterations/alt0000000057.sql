-- Deploy: schemas/launchql_public/tables/user_characteristics/columns/user_id/alterations/alt0000000057 to pg
-- made with <3 @ launchql.com

-- requires: schemas/launchql_public/schema
-- requires: schemas/launchql_public/tables/user_characteristics/table
-- requires: schemas/launchql_public/tables/user_characteristics/columns/user_id/column

BEGIN;

ALTER TABLE "launchql_public".user_characteristics 
    ALTER COLUMN user_id SET NOT NULL;
COMMIT;
