-- Deploy: schemas/launchql_public/tables/user_emails/columns/is_verified/alterations/alt0000000042 to pg
-- made with <3 @ launchql.com

-- requires: schemas/launchql_public/schema
-- requires: schemas/launchql_public/tables/user_emails/table
-- requires: schemas/launchql_public/tables/user_emails/columns/is_verified/column
-- requires: schemas/launchql_public/tables/user_emails/columns/is_verified/alterations/alt0000000041

BEGIN;

ALTER TABLE "launchql_public".user_emails 
    ALTER COLUMN is_verified SET DEFAULT false;
COMMIT;
