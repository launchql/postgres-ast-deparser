-- Revert schemas/files_private/grants/grant_schema_to_authenticated from pg

BEGIN;

REVOKE USAGE ON SCHEMA files_private FROM authenticated;

COMMIT;
