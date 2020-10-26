-- Deploy: schemas/launchql_public/tables/user_settings/columns/id/alterations/alt0000000051 to pg
-- made with <3 @ launchql.com

-- requires: schemas/launchql_public/schema
-- requires: schemas/launchql_public/tables/user_settings/table
-- requires: schemas/launchql_public/tables/user_settings/columns/id/column

BEGIN;

ALTER TABLE "launchql_public".user_settings 
    ALTER COLUMN id SET NOT NULL;
COMMIT;
