-- Deploy: schemas/launchql_public/tables/user_emails/alterations/alt0000000036 to pg
-- made with <3 @ launchql.com

-- requires: schemas/launchql_public/schema
-- requires: schemas/launchql_public/tables/user_emails/table

BEGIN;

ALTER TABLE "launchql_public".user_emails
    DISABLE ROW LEVEL SECURITY;
COMMIT;
