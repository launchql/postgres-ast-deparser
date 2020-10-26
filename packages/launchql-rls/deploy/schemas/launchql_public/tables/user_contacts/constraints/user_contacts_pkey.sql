-- Deploy: schemas/launchql_public/tables/user_contacts/constraints/user_contacts_pkey to pg
-- made with <3 @ launchql.com

-- requires: schemas/launchql_public/schema
-- requires: schemas/launchql_public/tables/user_contacts/table
-- requires: schemas/launchql_public/tables/user_contacts/columns/id/alterations/alt0000000060

BEGIN;

ALTER TABLE "launchql_public".user_contacts
    ADD CONSTRAINT user_contacts_pkey PRIMARY KEY (id);
COMMIT;
