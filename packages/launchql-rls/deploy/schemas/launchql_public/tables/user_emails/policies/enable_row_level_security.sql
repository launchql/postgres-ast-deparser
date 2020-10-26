-- Deploy: schemas/launchql_public/tables/user_emails/policies/enable_row_level_security to pg
-- made with <3 @ launchql.com

-- requires: schemas/launchql_public/schema
-- requires: schemas/launchql_public/tables/user_emails/table

BEGIN;

ALTER TABLE "launchql_public".user_emails
    ENABLE ROW LEVEL SECURITY;
COMMIT;
