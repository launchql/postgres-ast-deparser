-- Revert: schemas/launchql_public/tables/user_emails/columns/email/alterations/alt0000000040 from pg

BEGIN;


ALTER TABLE "launchql_rls_public".user_emails 
    ALTER COLUMN email DROP NOT NULL;


COMMIT;  

