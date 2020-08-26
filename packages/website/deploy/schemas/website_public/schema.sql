-- Deploy schemas/website_public/schema to pg


BEGIN;

CREATE SCHEMA website_public;

GRANT USAGE ON SCHEMA website_public
TO anonymous, authenticated;

ALTER DEFAULT PRIVILEGES IN SCHEMA website_public
GRANT EXECUTE ON FUNCTIONS
TO anonymous, authenticated;

COMMIT;
