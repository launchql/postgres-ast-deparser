-- Deploy: schemas/launchql_public/tables/user_emails/columns/user_id/column to pg
-- made with <3 @ launchql.com

-- requires: schemas/launchql_public/schema
-- requires: schemas/launchql_public/tables/user_emails/table
-- requires: schemas/launchql_public/tables/user_emails/columns/id/alterations/alt0000000038

BEGIN;

ALTER TABLE "launchql_public".user_emails ADD COLUMN user_id uuid;
COMMIT;
