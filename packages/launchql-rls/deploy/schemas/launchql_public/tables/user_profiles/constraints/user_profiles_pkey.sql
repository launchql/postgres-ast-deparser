-- Deploy: schemas/launchql_public/tables/user_profiles/constraints/user_profiles_pkey to pg
-- made with <3 @ launchql.com

-- requires: schemas/launchql_public/schema
-- requires: schemas/launchql_public/tables/user_profiles/table
-- requires: schemas/launchql_public/tables/user_profiles/columns/id/alterations/alt0000000047

BEGIN;

ALTER TABLE "launchql_public".user_profiles
    ADD CONSTRAINT user_profiles_pkey PRIMARY KEY (id);
COMMIT;
