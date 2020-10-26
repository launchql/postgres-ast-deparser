-- Deploy: schemas/launchql_public/tables/user_profiles/constraints/user_profiles_user_id_fkey to pg
-- made with <3 @ launchql.com

-- requires: schemas/launchql_public/schema
-- requires: schemas/launchql_public/tables/users/table
-- requires: schemas/launchql_public/tables/user_profiles/table
-- requires: schemas/launchql_public/tables/users/columns/id/column
-- requires: schemas/launchql_public/tables/user_profiles/columns/user_id/column
-- requires: schemas/launchql_public/tables/user_profiles/columns/user_id/alterations/alt0000000049

BEGIN;

ALTER TABLE "launchql_public".user_profiles 
    ADD CONSTRAINT user_profiles_user_id_fkey 
    FOREIGN KEY (user_id)
    REFERENCES "launchql_public".users (id)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION;
COMMIT;
