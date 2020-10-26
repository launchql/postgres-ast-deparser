-- Revert: schemas/launchql_public/tables/user_emails/columns/user_id/alterations/alt0000000039 from pg

BEGIN;


ALTER TABLE "launchql_rls_public".user_emails 
    ALTER COLUMN user_id DROP NOT NULL;


COMMIT;  

