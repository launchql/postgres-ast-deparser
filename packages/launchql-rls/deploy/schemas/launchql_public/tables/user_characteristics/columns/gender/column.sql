-- Deploy: schemas/launchql_public/tables/user_characteristics/columns/gender/column to pg
-- made with <3 @ launchql.com

-- requires: schemas/launchql_public/schema
-- requires: schemas/launchql_public/tables/user_characteristics/table
-- requires: schemas/launchql_public/tables/user_characteristics/columns/income/column

BEGIN;

ALTER TABLE "launchql_public".user_characteristics ADD COLUMN gender char;
COMMIT;
