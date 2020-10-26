-- Deploy: schemas/launchql_public/tables/user_profiles/columns/id/column to pg
-- made with <3 @ launchql.com

-- requires: schemas/launchql_public/schema
-- requires: schemas/launchql_public/tables/user_profiles/table
-- requires: schemas/launchql_public/tables/user_profiles/alterations/alt0000000045

BEGIN;

ALTER TABLE "launchql_public".user_profiles ADD COLUMN id uuid;
COMMIT;
