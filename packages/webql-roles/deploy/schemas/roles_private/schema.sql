-- Deploy schemas/roles_private/schema to pg


BEGIN;

CREATE SCHEMA roles_private;

ALTER DEFAULT PRIVILEGES IN SCHEMA roles_private
GRANT EXECUTE ON FUNCTIONS
TO authenticated;

COMMIT;
