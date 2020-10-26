-- Deploy: schemas/launchql_public/tables/user_connections/columns/id/alterations/alt0000000063 to pg
-- made with <3 @ launchql.com

-- requires: schemas/launchql_public/schema
-- requires: schemas/launchql_public/tables/user_connections/table
-- requires: schemas/launchql_public/tables/user_connections/columns/id/column

BEGIN;

ALTER TABLE "launchql_public".user_connections 
    ALTER COLUMN id SET NOT NULL;
COMMIT;
