-- Deploy: schemas/launchql_public/tables/user_profiles/columns/first_name/column to pg
-- made with <3 @ launchql.com

-- requires: schemas/launchql_public/schema
-- requires: schemas/launchql_public/tables/user_profiles/table
-- requires: schemas/launchql_public/tables/user_profiles/columns/reputation/alterations/alt0000000048

BEGIN;

ALTER TABLE "launchql_public".user_profiles ADD COLUMN first_name text;
COMMIT;
