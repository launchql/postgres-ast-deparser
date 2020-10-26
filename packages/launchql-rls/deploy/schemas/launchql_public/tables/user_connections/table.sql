-- Deploy: schemas/launchql_public/tables/user_connections/table to pg
-- made with <3 @ launchql.com

-- requires: schemas/launchql_public/schema
-- requires: schemas/launchql_public/tables/user_contacts/grants/authenticated/delete

BEGIN;
CREATE TABLE "launchql_public".user_connections (
  
);
COMMIT;
