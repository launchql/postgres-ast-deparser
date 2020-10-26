-- Deploy: schemas/launchql_public/tables/user_contacts/policies/enable_row_level_security to pg
-- made with <3 @ launchql.com

-- requires: schemas/launchql_public/schema
-- requires: schemas/launchql_public/tables/user_contacts/table
-- requires: schemas/launchql_public/tables/user_contacts/indexes/user_contacts_user_id_idx

BEGIN;

ALTER TABLE "launchql_public".user_contacts
    ENABLE ROW LEVEL SECURITY;
COMMIT;
