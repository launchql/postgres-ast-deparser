-- Deploy: schemas/launchql_public/tables/user_emails/columns/id/column to pg
-- made with <3 @ launchql.com

-- requires: schemas/launchql_public/schema
-- requires: schemas/launchql_public/tables/user_emails/table
-- requires: schemas/launchql_public/tables/user_emails/alterations/alt0000000036

BEGIN;

ALTER TABLE "launchql_public".user_emails ADD COLUMN id uuid;
COMMIT;
