-- Deploy: schemas/launchql_public/tables/user_connections/constraints/user_connections_requester_id_responder_id_key to pg
-- made with <3 @ launchql.com

-- requires: schemas/launchql_public/schema
-- requires: schemas/launchql_public/tables/user_connections/table
-- requires: schemas/launchql_public/tables/user_connections/indexes/user_connections_responder_id_idx

BEGIN;

ALTER TABLE "launchql_public".user_connections
    ADD CONSTRAINT user_connections_requester_id_responder_id_key UNIQUE (requester_id,responder_id);
COMMIT;
