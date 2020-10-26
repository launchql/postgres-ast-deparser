-- Deploy: schemas/launchql_public/tables/user_emails/constraints/user_emails_user_id_fkey to pg
-- made with <3 @ launchql.com

-- requires: schemas/launchql_public/schema
-- requires: schemas/launchql_public/tables/users/table
-- requires: schemas/launchql_public/tables/user_emails/table
-- requires: schemas/launchql_public/tables/users/columns/id/column
-- requires: schemas/launchql_public/tables/user_emails/columns/user_id/column
-- requires: schemas/launchql_public/tables/user_emails/grants/authenticated/delete

BEGIN;

ALTER TABLE "launchql_public".user_emails 
    ADD CONSTRAINT user_emails_user_id_fkey 
    FOREIGN KEY (user_id)
    REFERENCES "launchql_public".users (id)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION;
COMMIT;
