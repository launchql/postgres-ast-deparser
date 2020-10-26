-- Deploy: schemas/launchql_public/tables/user_settings/table to pg
-- made with <3 @ launchql.com

-- requires: schemas/launchql_public/schema
-- requires: schemas/launchql_public/tables/user_profiles/grants/authenticated/select

BEGIN;
CREATE TABLE "launchql_public".user_settings (
  
);
COMMIT;
