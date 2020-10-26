-- Deploy: schemas/launchql_public/tables/user_characteristics/alterations/alt0000000054 to pg
-- made with <3 @ launchql.com

-- requires: schemas/launchql_public/schema
-- requires: schemas/launchql_public/tables/user_characteristics/table

BEGIN;

ALTER TABLE "launchql_public".user_characteristics
    DISABLE ROW LEVEL SECURITY;
COMMIT;
