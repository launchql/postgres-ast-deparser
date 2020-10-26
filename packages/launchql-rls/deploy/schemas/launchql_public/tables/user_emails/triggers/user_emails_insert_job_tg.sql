-- Deploy: schemas/launchql_public/tables/user_emails/triggers/user_emails_insert_job_tg to pg
-- made with <3 @ launchql.com

-- requires: schemas/launchql_jobs/schema
-- requires: schemas/launchql_public/schema

BEGIN;

CREATE TRIGGER user_emails_insert_job_tg AFTER
INSERT
    ON "launchql_public".user_emails FOR EACH ROW
EXECUTE PROCEDURE "launchql_jobs".tg_add_job_with_row ('new-user-email');
COMMIT;
