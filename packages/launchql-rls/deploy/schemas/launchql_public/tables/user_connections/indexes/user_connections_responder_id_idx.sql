-- Deploy: schemas/launchql_public/tables/user_connections/indexes/user_connections_responder_id_idx to pg
-- made with <3 @ launchql.com

-- requires: schemas/launchql_public/schema
-- requires: schemas/launchql_public/tables/user_connections/table
-- requires: schemas/launchql_public/tables/user_connections/constraints/user_connections_responder_id_fkey

BEGIN;

CREATE INDEX user_connections_responder_id_idx ON "launchql_public".user_connections (responder_id);
COMMIT;
