-- Deploy schemas/projects_private/schema to pg


BEGIN;

CREATE SCHEMA projects_private;

GRANT USAGE ON SCHEMA projects_private
TO authenticated;

ALTER DEFAULT PRIVILEGES IN SCHEMA projects_private
GRANT EXECUTE ON FUNCTIONS
TO authenticated;

COMMIT;
