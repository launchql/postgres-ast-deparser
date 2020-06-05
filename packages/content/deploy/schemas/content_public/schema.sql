-- Deploy schemas/content_public/schema to pg


BEGIN;

CREATE SCHEMA content_public;
 
GRANT USAGE ON SCHEMA content_public
TO authenticated, anonymous;

ALTER DEFAULT PRIVILEGES IN SCHEMA content_public
GRANT EXECUTE ON FUNCTIONS
TO authenticated;

COMMIT;
