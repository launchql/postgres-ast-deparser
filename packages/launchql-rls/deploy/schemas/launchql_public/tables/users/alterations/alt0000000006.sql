-- Deploy: schemas/launchql_public/tables/users/alterations/alt0000000006 to pg
-- made with <3 @ launchql.com

-- requires: schemas/launchql_public/schema
-- requires: schemas/launchql_public/tables/users/table

BEGIN;

ALTER TABLE "launchql_public".users
    DISABLE ROW LEVEL SECURITY;
COMMIT;
