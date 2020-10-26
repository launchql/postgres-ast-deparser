-- Revert: schemas/launchql_public/tables/user_contacts/columns/user_id/alterations/alt0000000061 from pg

BEGIN;


ALTER TABLE "launchql_rls_public".user_contacts 
    ALTER COLUMN user_id DROP NOT NULL;


COMMIT;  

