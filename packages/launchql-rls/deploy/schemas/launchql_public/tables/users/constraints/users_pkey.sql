-- Deploy: schemas/launchql_public/tables/users/constraints/users_pkey to pg
-- made with <3 @ launchql.com

-- requires: schemas/launchql_public/schema
-- requires: schemas/launchql_public/tables/users/table
-- requires: schemas/launchql_public/tables/users/columns/id/alterations/alt0000000008

BEGIN;

ALTER TABLE "launchql_public".users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);
COMMIT;
