-- Deploy schemas/files_private/grants/grant_schema_to_authenticated to pg

-- requires: schemas/files_private/schema

BEGIN;

GRANT USAGE ON SCHEMA files_private TO authenticated;

COMMIT;
