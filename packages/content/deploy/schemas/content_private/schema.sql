-- Deploy schemas/content_private/schema to pg


BEGIN;

CREATE SCHEMA content_private;

GRANT USAGE ON SCHEMA content_private TO authenticated;

COMMIT;
