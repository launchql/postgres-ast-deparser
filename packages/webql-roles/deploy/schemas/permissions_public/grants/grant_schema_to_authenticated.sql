-- Deploy schemas/permissions_public/grants/grant_schema_to_authenticated to pg

-- requires: schemas/permissions_public/schema

BEGIN;

GRANT USAGE ON SCHEMA permissions_public TO authenticated;

COMMIT;
