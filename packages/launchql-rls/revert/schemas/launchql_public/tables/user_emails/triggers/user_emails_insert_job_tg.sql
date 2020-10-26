-- Revert: schemas/launchql_public/tables/user_emails/triggers/user_emails_insert_job_tg from pg

BEGIN;


DROP TRIGGER user_emails_insert_job_tg
    ON "launchql_rls_public".user_emails;
COMMIT;  

