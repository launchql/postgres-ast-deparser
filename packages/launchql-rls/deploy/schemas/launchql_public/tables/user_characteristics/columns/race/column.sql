-- Deploy: schemas/launchql_public/tables/user_characteristics/columns/race/column to pg
-- made with <3 @ launchql.com

-- requires: schemas/launchql_public/schema
-- requires: schemas/launchql_public/tables/user_characteristics/table
-- requires: schemas/launchql_public/tables/user_characteristics/columns/gender/column

BEGIN;

ALTER TABLE "launchql_public".user_characteristics ADD COLUMN race text;
COMMIT;
