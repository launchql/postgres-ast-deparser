-- Deploy schemas/deparser/schema to pg


BEGIN;

CREATE SCHEMA deparser;
GRANT USAGE ON SCHEMA deparser TO public;

ALTER DEFAULT PRIVILEGES IN SCHEMA deparser
GRANT EXECUTE ON FUNCTIONS
TO public;

COMMIT;
