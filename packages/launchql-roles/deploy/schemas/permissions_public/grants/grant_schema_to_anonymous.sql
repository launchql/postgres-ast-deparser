-- Deploy schemas/permissions_public/grants/grant_schema_to_anonymous to pg

-- requires: schemas/permissions_public/schema

BEGIN;

GRANT USAGE ON SCHEMA permissions_public TO anonymous;

COMMIT;
