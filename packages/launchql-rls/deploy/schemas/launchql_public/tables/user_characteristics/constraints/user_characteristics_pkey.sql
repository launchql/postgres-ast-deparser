-- Deploy: schemas/launchql_public/tables/user_characteristics/constraints/user_characteristics_pkey to pg
-- made with <3 @ launchql.com

-- requires: schemas/launchql_public/schema
-- requires: schemas/launchql_public/tables/user_characteristics/table
-- requires: schemas/launchql_public/tables/user_characteristics/columns/id/alterations/alt0000000056

BEGIN;

ALTER TABLE "launchql_public".user_characteristics
    ADD CONSTRAINT user_characteristics_pkey PRIMARY KEY (id);
COMMIT;
