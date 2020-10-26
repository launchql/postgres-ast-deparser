-- Revert: schemas/launchql_public/tables/user_contacts/alterations/alt0000000058 from pg

BEGIN;


ALTER TABLE "launchql_rls_public".user_contacts
    ENABLE ROW LEVEL SECURITY;

COMMIT;  

