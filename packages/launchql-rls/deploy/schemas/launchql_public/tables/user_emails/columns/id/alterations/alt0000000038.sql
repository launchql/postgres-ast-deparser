-- Deploy: schemas/launchql_public/tables/user_emails/columns/id/alterations/alt0000000038 to pg
-- made with <3 @ launchql.com

-- requires: schemas/launchql_public/schema
-- requires: schemas/launchql_public/tables/user_emails/table
-- requires: schemas/launchql_public/tables/user_emails/columns/id/column
-- requires: schemas/launchql_public/tables/user_emails/columns/id/alterations/alt0000000037

BEGIN;

ALTER TABLE "launchql_public".user_emails 
    ALTER COLUMN id SET DEFAULT "launchql_private".uuid_generate_v4();
COMMIT;
