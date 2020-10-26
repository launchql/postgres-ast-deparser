-- Revert: schemas/launchql_public/tables/user_emails/grants/authenticated/insert from pg

BEGIN;
REVOKE INSERT ON TABLE "launchql_rls_public".user_emails FROM authenticated;
COMMIT;  

