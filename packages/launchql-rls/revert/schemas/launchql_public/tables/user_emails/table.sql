-- Revert: schemas/launchql_public/tables/user_emails/table from pg

BEGIN;
DROP TABLE "launchql_rls_public".user_emails;
COMMIT;  

