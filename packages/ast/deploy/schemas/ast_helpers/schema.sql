-- Deploy schemas/ast_helpers/schema to pg


BEGIN;

CREATE SCHEMA ast_helpers;
GRANT USAGE ON SCHEMA ast_helpers TO public;

ALTER DEFAULT PRIVILEGES IN SCHEMA ast_helpers
GRANT EXECUTE ON FUNCTIONS
TO public;

COMMIT;
