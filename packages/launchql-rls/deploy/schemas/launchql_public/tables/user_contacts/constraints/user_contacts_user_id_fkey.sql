-- Deploy: schemas/launchql_public/tables/user_contacts/constraints/user_contacts_user_id_fkey to pg
-- made with <3 @ launchql.com

-- requires: schemas/launchql_public/schema
-- requires: schemas/launchql_public/tables/users/table
-- requires: schemas/launchql_public/tables/user_contacts/table
-- requires: schemas/launchql_public/tables/users/columns/id/column
-- requires: schemas/launchql_public/tables/user_contacts/columns/user_id/column
-- requires: schemas/launchql_public/tables/user_contacts/columns/user_id/alterations/alt0000000061

BEGIN;

ALTER TABLE "launchql_public".user_contacts 
    ADD CONSTRAINT user_contacts_user_id_fkey 
    FOREIGN KEY (user_id)
    REFERENCES "launchql_public".users (id)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION;
COMMIT;
