-- Revert schemas/roles_private/grants/grant_schema_to_anonymous from pg

BEGIN;

REVOKE USAGE ON SCHEMA roles_private FROM anonymous;

COMMIT;
