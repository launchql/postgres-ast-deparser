-- Deploy schemas/website_private/schema to pg


BEGIN;

CREATE SCHEMA website_private;

GRANT USAGE ON SCHEMA website_private
TO anonymous;

ALTER DEFAULT PRIVILEGES IN SCHEMA website_private
GRANT EXECUTE ON FUNCTIONS
TO anonymous;

COMMIT;
