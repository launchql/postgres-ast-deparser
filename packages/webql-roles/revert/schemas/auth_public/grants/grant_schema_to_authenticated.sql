-- Revert schemas/auth_public/grants/grant_schema_to_authenticated from pg

BEGIN;

REVOKE USAGE ON SCHEMA auth_public FROM authenticated;

COMMIT;
