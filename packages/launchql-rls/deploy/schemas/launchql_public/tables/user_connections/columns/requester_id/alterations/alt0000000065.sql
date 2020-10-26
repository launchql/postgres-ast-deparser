-- Deploy: schemas/launchql_public/tables/user_connections/columns/requester_id/alterations/alt0000000065 to pg
-- made with <3 @ launchql.com

-- requires: schemas/launchql_public/schema
-- requires: schemas/launchql_public/tables/user_connections/table
-- requires: schemas/launchql_public/tables/user_connections/columns/requester_id/column

BEGIN;

ALTER TABLE "launchql_public".user_connections 
    ALTER COLUMN requester_id SET NOT NULL;
COMMIT;
