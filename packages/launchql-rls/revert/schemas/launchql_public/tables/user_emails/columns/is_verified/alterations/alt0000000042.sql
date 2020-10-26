-- Revert: schemas/launchql_public/tables/user_emails/columns/is_verified/alterations/alt0000000042 from pg

BEGIN;


ALTER TABLE "launchql_rls_public".user_emails 
    ALTER COLUMN is_verified DROP DEFAULT;

COMMIT;  

