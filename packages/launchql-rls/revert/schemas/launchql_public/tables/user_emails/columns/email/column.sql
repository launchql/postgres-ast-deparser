-- Revert: schemas/launchql_public/tables/user_emails/columns/email/column from pg

BEGIN;


ALTER TABLE "launchql_rls_public".user_emails DROP COLUMN email;
COMMIT;  

