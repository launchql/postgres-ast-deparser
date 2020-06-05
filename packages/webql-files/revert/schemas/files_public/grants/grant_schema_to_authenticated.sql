-- Revert schemas/files_public/grants/grant_schema_to_authenticated from pg

BEGIN;

REVOKE USAGE ON SCHEMA files_public FROM authenticated;

COMMIT;
