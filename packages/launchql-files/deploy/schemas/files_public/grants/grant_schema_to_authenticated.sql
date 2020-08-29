-- Deploy schemas/files_public/grants/grant_schema_to_authenticated to pg

-- requires: schemas/files_public/schema

BEGIN;

GRANT USAGE ON SCHEMA files_public TO authenticated;

COMMIT;
