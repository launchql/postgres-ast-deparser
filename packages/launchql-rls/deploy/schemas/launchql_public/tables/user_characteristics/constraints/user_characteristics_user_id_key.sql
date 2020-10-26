-- Deploy: schemas/launchql_public/tables/user_characteristics/constraints/user_characteristics_user_id_key to pg
-- made with <3 @ launchql.com

-- requires: schemas/launchql_public/schema
-- requires: schemas/launchql_public/tables/user_characteristics/table
-- requires: schemas/launchql_public/tables/user_characteristics/indexes/user_characteristics_user_id_idx

BEGIN;

ALTER TABLE "launchql_public".user_characteristics
    ADD CONSTRAINT user_characteristics_user_id_key UNIQUE (user_id);
COMMIT;
