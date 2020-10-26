-- Deploy: schemas/launchql_public/tables/user_connections/alterations/alt0000000062 to pg
-- made with <3 @ launchql.com

-- requires: schemas/launchql_public/schema
-- requires: schemas/launchql_public/tables/user_connections/table

BEGIN;

ALTER TABLE "launchql_public".user_connections
    DISABLE ROW LEVEL SECURITY;
COMMIT;
