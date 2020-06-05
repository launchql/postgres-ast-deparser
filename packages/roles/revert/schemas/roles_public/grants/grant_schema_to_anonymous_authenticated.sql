-- Revert schemas/roles_public/grants/grant_schema_to_anonymous_authenticated from pg

BEGIN;

REVOKE USAGE ON SCHEMA roles_public
FROM anonymous,authenticated;

COMMIT;
