-- Revert: schemas/launchql_public/tables/user_emails/columns/id/alterations/alt0000000038 from pg

BEGIN;


ALTER TABLE "launchql_rls_public".user_emails 
    ALTER COLUMN id DROP DEFAULT;

COMMIT;  

