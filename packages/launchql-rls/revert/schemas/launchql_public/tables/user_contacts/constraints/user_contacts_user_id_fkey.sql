-- Revert: schemas/launchql_public/tables/user_contacts/constraints/user_contacts_user_id_fkey from pg

BEGIN;


ALTER TABLE "launchql_rls_public".user_contacts 
    DROP CONSTRAINT user_contacts_user_id_fkey;

COMMIT;  

