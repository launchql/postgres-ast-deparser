-- Deploy: schemas/launchql_public/tables/user_contacts/indexes/user_contacts_user_id_idx to pg
-- made with <3 @ launchql.com

-- requires: schemas/launchql_public/schema
-- requires: schemas/launchql_public/tables/user_contacts/table
-- requires: schemas/launchql_public/tables/user_contacts/constraints/user_contacts_user_id_fkey

BEGIN;

CREATE INDEX user_contacts_user_id_idx ON "launchql_public".user_contacts (user_id);
COMMIT;
