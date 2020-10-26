-- Revert: schemas/launchql_public/tables/user_emails/columns/id/column from pg

BEGIN;


ALTER TABLE "launchql_rls_public".user_emails DROP COLUMN id;
COMMIT;  

