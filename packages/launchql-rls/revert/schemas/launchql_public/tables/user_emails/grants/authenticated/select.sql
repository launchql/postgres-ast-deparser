-- Revert: schemas/launchql_public/tables/user_emails/grants/authenticated/select from pg

BEGIN;
REVOKE SELECT ON TABLE "launchql_rls_public".user_emails FROM authenticated;
COMMIT;  

