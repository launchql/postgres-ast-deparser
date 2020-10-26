-- Revert: schemas/launchql_public/tables/user_emails/grants/authenticated/delete from pg

BEGIN;
REVOKE DELETE ON TABLE "launchql_rls_public".user_emails FROM authenticated;
COMMIT;  

