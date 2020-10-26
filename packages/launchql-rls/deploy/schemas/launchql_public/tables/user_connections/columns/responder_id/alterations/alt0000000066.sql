-- Deploy: schemas/launchql_public/tables/user_connections/columns/responder_id/alterations/alt0000000066 to pg
-- made with <3 @ launchql.com

-- requires: schemas/launchql_public/schema
-- requires: schemas/launchql_public/tables/user_connections/table
-- requires: schemas/launchql_public/tables/user_connections/columns/responder_id/column

BEGIN;

ALTER TABLE "launchql_public".user_connections 
    ALTER COLUMN responder_id SET NOT NULL;
COMMIT;
