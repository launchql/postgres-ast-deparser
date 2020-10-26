-- Deploy: schemas/launchql_public/tables/user_profiles/columns/desired/column to pg
-- made with <3 @ launchql.com

-- requires: schemas/launchql_public/schema
-- requires: schemas/launchql_public/tables/user_profiles/table
-- requires: schemas/launchql_public/tables/user_profiles/columns/tags/column

BEGIN;

ALTER TABLE "launchql_public".user_profiles ADD COLUMN desired citext[];
COMMIT;
