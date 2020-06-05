-- Revert schemas/roles_private/grants/grant_schema_to_authenticated from pg

BEGIN;

REVOKE USAGE ON SCHEMA roles_private FROM authenticated;

COMMIT;
