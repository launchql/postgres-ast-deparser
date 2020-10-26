-- Deploy: schemas/launchql_private/schema to pg
-- made with <3 @ launchql.com

-- requires: schemas/launchql_public/grants/usage/anonymous

BEGIN;

CREATE SCHEMA "launchql_private";
COMMIT;
