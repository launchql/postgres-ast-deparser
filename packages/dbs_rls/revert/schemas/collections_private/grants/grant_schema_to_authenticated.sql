-- Revert schemas/collections_private/grants/grant_schema_to_authenticated from pg

BEGIN;

REVOKE USAGE ON SCHEMA collections_private FROM authenticated;

COMMIT;
