-- Revert: schemas/launchql_public/tables/user_emails/columns/user_id/column from pg

BEGIN;


ALTER TABLE "launchql_rls_public".user_emails DROP COLUMN user_id;
COMMIT;  

