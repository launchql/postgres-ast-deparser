-- Deploy schemas/collections_public/grants/grant_schema_to_authenticated to pg

-- requires: schemas/collections_public/schema

BEGIN;

GRANT USAGE ON SCHEMA collections_public TO authenticated;

COMMIT;
