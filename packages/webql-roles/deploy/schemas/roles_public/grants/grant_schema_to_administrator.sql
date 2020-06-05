-- Deploy schemas/roles_public/grants/grant_schema_to_administrator to pg

-- requires: schemas/roles_public/schema

BEGIN;

GRANT USAGE ON SCHEMA roles_public
TO administrator;

COMMIT;
