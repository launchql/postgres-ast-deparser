-- Deploy schemas/ast_utils/schema to pg


BEGIN;

CREATE SCHEMA ast_utils;
GRANT USAGE ON SCHEMA ast_utils TO public;

ALTER DEFAULT PRIVILEGES IN SCHEMA ast_utils
GRANT EXECUTE ON FUNCTIONS
TO public;

COMMIT;
