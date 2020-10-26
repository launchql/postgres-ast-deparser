-- Revert: schemas/launchql_public/tables/user_emails/columns/is_verified/alterations/alt0000000041 from pg

BEGIN;


ALTER TABLE "launchql_rls_public".user_emails 
    ALTER COLUMN is_verified DROP NOT NULL;


COMMIT;  

