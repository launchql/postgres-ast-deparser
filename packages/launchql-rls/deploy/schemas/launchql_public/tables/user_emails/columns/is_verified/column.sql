-- Deploy: schemas/launchql_public/tables/user_emails/columns/is_verified/column to pg
-- made with <3 @ launchql.com

-- requires: schemas/launchql_public/schema
-- requires: schemas/launchql_public/tables/user_emails/table
-- requires: schemas/launchql_public/tables/user_emails/columns/email/alterations/alt0000000040

BEGIN;

ALTER TABLE "launchql_public".user_emails ADD COLUMN is_verified boolean;
COMMIT;