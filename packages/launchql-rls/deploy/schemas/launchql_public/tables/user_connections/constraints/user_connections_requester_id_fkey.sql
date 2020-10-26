-- Deploy: schemas/launchql_public/tables/user_connections/constraints/user_connections_requester_id_fkey to pg
-- made with <3 @ launchql.com

-- requires: schemas/launchql_public/schema
-- requires: schemas/launchql_public/tables/users/table
-- requires: schemas/launchql_public/tables/user_connections/table
-- requires: schemas/launchql_public/tables/users/columns/id/column
-- requires: schemas/launchql_public/tables/user_connections/columns/requester_id/column
-- requires: schemas/launchql_public/tables/user_connections/columns/requester_id/alterations/alt0000000065

BEGIN;

ALTER TABLE "launchql_public".user_connections 
    ADD CONSTRAINT user_connections_requester_id_fkey 
    FOREIGN KEY (requester_id)
    REFERENCES "launchql_public".users (id)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION;
COMMIT;
