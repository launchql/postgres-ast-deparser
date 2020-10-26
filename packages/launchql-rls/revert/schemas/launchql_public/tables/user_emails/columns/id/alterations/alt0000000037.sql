-- Revert: schemas/launchql_public/tables/user_emails/columns/id/alterations/alt0000000037 from pg

BEGIN;


ALTER TABLE "launchql_rls_public".user_emails 
    ALTER COLUMN id DROP NOT NULL;


COMMIT;  

