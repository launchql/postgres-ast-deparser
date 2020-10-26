-- Deploy: schemas/launchql_public/tables/user_settings/alterations/alt0000000050 to pg
-- made with <3 @ launchql.com

-- requires: schemas/launchql_public/schema
-- requires: schemas/launchql_public/tables/user_settings/table

BEGIN;

ALTER TABLE "launchql_public".user_settings
    DISABLE ROW LEVEL SECURITY;
COMMIT;
