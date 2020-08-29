-- Deploy schemas/projects_public/schema to pg


BEGIN;

CREATE SCHEMA projects_public;

GRANT USAGE ON SCHEMA projects_public
TO authenticated;

ALTER DEFAULT PRIVILEGES IN SCHEMA projects_public
GRANT EXECUTE ON FUNCTIONS
TO authenticated;

COMMIT;
