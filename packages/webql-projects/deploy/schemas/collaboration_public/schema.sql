-- Deploy schemas/collaboration_public/schema to pg


BEGIN;

CREATE SCHEMA collaboration_public;

GRANT USAGE ON SCHEMA collaboration_public
TO authenticated, anonymous;

ALTER DEFAULT PRIVILEGES IN SCHEMA collaboration_public
GRANT EXECUTE ON FUNCTIONS
TO authenticated;

COMMIT;
