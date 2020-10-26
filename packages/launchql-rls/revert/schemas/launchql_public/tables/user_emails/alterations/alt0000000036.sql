-- Revert: schemas/launchql_public/tables/user_emails/alterations/alt0000000036 from pg

BEGIN;


ALTER TABLE "launchql_rls_public".user_emails
    ENABLE ROW LEVEL SECURITY;

COMMIT;  

