-- Deploy schemas/roles_public/grants/grant_schema_to_anonymous_authenticated to pg

-- requires: schemas/roles_public/schema

BEGIN;

GRANT USAGE ON SCHEMA roles_public
TO anonymous,authenticated;

COMMIT;
