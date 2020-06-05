-- Revert schemas/auth_public/grants/grant_schema_to_anonymous from pg

BEGIN;

REVOKE USAGE ON SCHEMA auth_public FROM anonymous;

COMMIT;
