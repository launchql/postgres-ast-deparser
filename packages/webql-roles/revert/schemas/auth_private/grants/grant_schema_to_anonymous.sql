-- Revert schemas/auth_private/grants/grant_schema_to_anonymous from pg

BEGIN;

REVOKE USAGE ON SCHEMA auth_private FROM anonymous;

COMMIT;
