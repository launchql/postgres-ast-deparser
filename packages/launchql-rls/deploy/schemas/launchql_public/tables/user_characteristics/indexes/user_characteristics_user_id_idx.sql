-- Deploy: schemas/launchql_public/tables/user_characteristics/indexes/user_characteristics_user_id_idx to pg
-- made with <3 @ launchql.com

-- requires: schemas/launchql_public/schema
-- requires: schemas/launchql_public/tables/user_characteristics/table
-- requires: schemas/launchql_public/tables/user_characteristics/constraints/user_characteristics_user_id_fkey

BEGIN;

CREATE INDEX user_characteristics_user_id_idx ON "launchql_public".user_characteristics (user_id);
COMMIT;
