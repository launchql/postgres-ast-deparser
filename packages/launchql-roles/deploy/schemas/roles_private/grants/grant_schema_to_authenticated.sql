-- Deploy schemas/roles_private/grants/grant_schema_to_authenticated to pg

-- requires: schemas/roles_private/schema

BEGIN;

GRANT USAGE ON SCHEMA roles_private TO authenticated;

COMMIT;
