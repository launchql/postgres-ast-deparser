-- Deploy: schemas/launchql_public/tables/user_settings/columns/id/alterations/alt0000000052 to pg
-- made with <3 @ launchql.com

-- requires: schemas/launchql_public/schema
-- requires: schemas/launchql_public/tables/user_settings/table
-- requires: schemas/launchql_public/tables/user_settings/columns/id/column
-- requires: schemas/launchql_public/tables/user_settings/columns/id/alterations/alt0000000051

BEGIN;

ALTER TABLE "launchql_public".user_settings 
    ALTER COLUMN id SET DEFAULT "launchql_private".uuid_generate_v4();
COMMIT;
