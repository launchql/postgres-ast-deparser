-- Deploy: schemas/launchql_public/tables/user_characteristics/columns/income/column to pg
-- made with <3 @ launchql.com

-- requires: schemas/launchql_public/schema
-- requires: schemas/launchql_public/tables/user_characteristics/table
-- requires: schemas/launchql_public/tables/user_characteristics/constraints/user_characteristics_pkey

BEGIN;

ALTER TABLE "launchql_public".user_characteristics ADD COLUMN income numeric;
COMMIT;