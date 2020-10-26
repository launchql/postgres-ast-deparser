-- Deploy: schemas/launchql_public/tables/user_connections/constraints/user_connections_pkey to pg
-- made with <3 @ launchql.com

-- requires: schemas/launchql_public/schema
-- requires: schemas/launchql_public/tables/user_connections/table
-- requires: schemas/launchql_public/tables/user_connections/columns/id/alterations/alt0000000064

BEGIN;

ALTER TABLE "launchql_public".user_connections
    ADD CONSTRAINT user_connections_pkey PRIMARY KEY (id);
COMMIT;
