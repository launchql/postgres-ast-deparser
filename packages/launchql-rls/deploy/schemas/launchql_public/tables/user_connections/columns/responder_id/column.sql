-- Deploy: schemas/launchql_public/tables/user_connections/columns/responder_id/column to pg
-- made with <3 @ launchql.com

-- requires: schemas/launchql_public/schema
-- requires: schemas/launchql_public/tables/user_connections/table
-- requires: schemas/launchql_public/tables/user_connections/indexes/user_connections_requester_id_idx

BEGIN;

ALTER TABLE "launchql_public".user_connections ADD COLUMN responder_id uuid;
COMMIT;
