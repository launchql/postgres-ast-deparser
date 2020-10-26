-- Revert: schemas/launchql_public/tables/user_emails/grants/authenticated/update from pg

BEGIN;
REVOKE UPDATE ON TABLE "launchql_rls_public".user_emails FROM authenticated;
COMMIT;  

