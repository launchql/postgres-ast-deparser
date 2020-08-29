-- Revert schemas/permissions_public/grants/grant_schema_to_anonymous from pg

BEGIN;

REVOKE USAGE ON SCHEMA permissions_public FROM anonymous;

COMMIT;
