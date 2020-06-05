-- Deploy schemas/auth_private/grants/grant_schema_to_anonymous to pg

-- requires: schemas/auth_private/schema

BEGIN;

GRANT USAGE ON SCHEMA auth_private TO anonymous;

COMMIT;
