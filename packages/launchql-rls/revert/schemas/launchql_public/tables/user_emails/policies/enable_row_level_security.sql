-- Revert: schemas/launchql_public/tables/user_emails/policies/enable_row_level_security from pg

BEGIN;


ALTER TABLE "launchql_rls_public".user_emails
    DISABLE ROW LEVEL SECURITY;

COMMIT;  

