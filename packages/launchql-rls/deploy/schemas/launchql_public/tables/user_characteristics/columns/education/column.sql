-- Deploy: schemas/launchql_public/tables/user_characteristics/columns/education/column to pg
-- made with <3 @ launchql.com

-- requires: schemas/launchql_public/schema
-- requires: schemas/launchql_public/tables/user_characteristics/table
-- requires: schemas/launchql_public/tables/user_characteristics/columns/dob/column

BEGIN;

ALTER TABLE "launchql_public".user_characteristics ADD COLUMN education text;
COMMIT;
