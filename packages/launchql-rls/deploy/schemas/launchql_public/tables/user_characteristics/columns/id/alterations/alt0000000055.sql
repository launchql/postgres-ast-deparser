-- Deploy: schemas/launchql_public/tables/user_characteristics/columns/id/alterations/alt0000000055 to pg
-- made with <3 @ launchql.com

-- requires: schemas/launchql_public/schema
-- requires: schemas/launchql_public/tables/user_characteristics/table
-- requires: schemas/launchql_public/tables/user_characteristics/columns/id/column

BEGIN;

ALTER TABLE "launchql_public".user_characteristics 
    ALTER COLUMN id SET NOT NULL;
COMMIT;
