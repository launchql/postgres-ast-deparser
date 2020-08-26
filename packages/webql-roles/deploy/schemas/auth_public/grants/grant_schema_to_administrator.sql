-- Deploy schemas/auth_public/grants/grant_schema_to_administrator to pg

-- requires: schemas/auth_public/schema

BEGIN;

GRANT USAGE ON SCHEMA auth_public TO administrator;

COMMIT;
