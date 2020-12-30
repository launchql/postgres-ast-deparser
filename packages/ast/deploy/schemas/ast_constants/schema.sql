-- Deploy schemas/ast_constants/schema to pg


BEGIN;

CREATE SCHEMA ast_constants;
GRANT USAGE ON SCHEMA ast_constants TO public;

ALTER DEFAULT PRIVILEGES IN SCHEMA ast_constants
GRANT EXECUTE ON FUNCTIONS
TO public;

COMMIT;
