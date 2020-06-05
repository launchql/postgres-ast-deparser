-- Revert schemas/roles_public/grants/grant_schema_to_administrator from pg

BEGIN;

REVOKE USAGE ON SCHEMA roles_public FROM administrator;

COMMIT;
