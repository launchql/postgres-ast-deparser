-- Revert schemas/collections_public/grants/grant_schema_to_authenticated from pg

BEGIN;

REVOKE USAGE ON SCHEMA collections_public FROM authenticated;

COMMIT;
