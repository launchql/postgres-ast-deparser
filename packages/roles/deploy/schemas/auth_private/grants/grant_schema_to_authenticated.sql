-- Deploy schemas/auth_private/grants/grant_schema_to_authenticated to pg

-- requires: schemas/auth_private/schema

BEGIN;

GRANT USAGE ON SCHEMA auth_private TO authenticated;

COMMIT;
