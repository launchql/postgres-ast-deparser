-- Deploy schemas/collaboration_private/schema to pg


BEGIN;

CREATE SCHEMA collaboration_private;

GRANT USAGE ON SCHEMA collaboration_private
TO authenticated, anonymous;

ALTER DEFAULT PRIVILEGES IN SCHEMA collaboration_private
GRANT EXECUTE ON FUNCTIONS
TO authenticated;

COMMIT;
