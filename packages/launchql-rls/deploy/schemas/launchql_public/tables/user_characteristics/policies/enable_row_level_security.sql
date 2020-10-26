-- Deploy: schemas/launchql_public/tables/user_characteristics/policies/enable_row_level_security to pg
-- made with <3 @ launchql.com

-- requires: schemas/launchql_public/schema
-- requires: schemas/launchql_public/tables/user_characteristics/table
-- requires: schemas/launchql_public/tables/user_characteristics/constraints/user_characteristics_user_id_key

BEGIN;

ALTER TABLE "launchql_public".user_characteristics
    ENABLE ROW LEVEL SECURITY;
COMMIT;
