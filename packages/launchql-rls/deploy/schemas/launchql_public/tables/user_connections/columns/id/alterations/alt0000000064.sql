-- Deploy: schemas/launchql_public/tables/user_connections/columns/id/alterations/alt0000000064 to pg
-- made with <3 @ launchql.com

-- requires: schemas/launchql_public/schema
-- requires: schemas/launchql_public/tables/user_connections/table
-- requires: schemas/launchql_public/tables/user_connections/columns/id/column
-- requires: schemas/launchql_public/tables/user_connections/columns/id/alterations/alt0000000063

BEGIN;

ALTER TABLE "launchql_public".user_connections 
    ALTER COLUMN id SET DEFAULT "launchql_private".uuid_generate_v4();
COMMIT;
