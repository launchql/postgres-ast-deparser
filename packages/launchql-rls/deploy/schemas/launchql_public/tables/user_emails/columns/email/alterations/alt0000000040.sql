-- Deploy: schemas/launchql_public/tables/user_emails/columns/email/alterations/alt0000000040 to pg
-- made with <3 @ launchql.com

-- requires: schemas/launchql_public/schema
-- requires: schemas/launchql_public/tables/user_emails/table
-- requires: schemas/launchql_public/tables/user_emails/columns/email/column

BEGIN;

ALTER TABLE "launchql_public".user_emails 
    ALTER COLUMN email SET NOT NULL;
COMMIT;
