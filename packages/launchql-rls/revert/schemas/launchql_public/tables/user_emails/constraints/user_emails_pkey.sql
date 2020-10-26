-- Revert: schemas/launchql_public/tables/user_emails/constraints/user_emails_pkey from pg

BEGIN;


ALTER TABLE "launchql_rls_public".user_emails 
    DROP CONSTRAINT user_emails_pkey;

COMMIT;  

