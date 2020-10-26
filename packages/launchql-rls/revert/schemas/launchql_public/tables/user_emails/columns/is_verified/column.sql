-- Revert: schemas/launchql_public/tables/user_emails/columns/is_verified/column from pg

BEGIN;


ALTER TABLE "launchql_rls_public".user_emails DROP COLUMN is_verified;
COMMIT;  

