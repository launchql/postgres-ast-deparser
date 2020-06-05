-- Deploy schemas/permissions_private/schema to pg


BEGIN;

CREATE SCHEMA permissions_private;

GRANT USAGE ON SCHEMA permissions_private
TO authenticated, anonymous;

ALTER DEFAULT PRIVILEGES IN SCHEMA permissions_private
GRANT EXECUTE ON FUNCTIONS
TO authenticated;

COMMIT;
