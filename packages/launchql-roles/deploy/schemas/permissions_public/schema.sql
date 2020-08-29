-- Deploy schemas/permissions_public/schema to pg


BEGIN;

CREATE SCHEMA permissions_public;
 
GRANT USAGE ON SCHEMA permissions_public
TO authenticated, anonymous;

ALTER DEFAULT PRIVILEGES IN SCHEMA permissions_public
GRANT EXECUTE ON FUNCTIONS
TO authenticated;

COMMIT;
