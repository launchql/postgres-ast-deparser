-- Deploy: schemas/launchql_public/tables/user_characteristics/constraints/user_characteristics_user_id_fkey to pg
-- made with <3 @ launchql.com

-- requires: schemas/launchql_public/schema
-- requires: schemas/launchql_public/tables/users/table
-- requires: schemas/launchql_public/tables/users/columns/id/column
-- requires: schemas/launchql_public/tables/user_characteristics/table
-- requires: schemas/launchql_public/tables/user_characteristics/columns/user_id/column
-- requires: schemas/launchql_public/tables/user_characteristics/columns/user_id/alterations/alt0000000057

BEGIN;

ALTER TABLE "launchql_public".user_characteristics 
    ADD CONSTRAINT user_characteristics_user_id_fkey 
    FOREIGN KEY (user_id)
    REFERENCES "launchql_public".users (id)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION;
COMMIT;
